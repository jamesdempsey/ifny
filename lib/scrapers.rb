module Scrapers
  def scrape_ifc_doc(film_url)
    unless Film.find_by_url(film_url)
      ifc = Theater.find_by_url(Theater.ifc_url)

      film_doc = Nokogiri::HTML(open(film_url))

      film_title = film_doc.css('.post h1').first.content

      p_nodes = film_doc.css('.post p').select do |p_node|
        p_node.content.split.size > 30
      end

      film_desc = p_nodes.first.content

      unless remote_poster_url = scrape_imdb_poster(film_title)
        remote_poster_url = film_doc.css('.post img').first.attributes['src'].value
      end

      film = Film.create!(title: film_title, description: film_desc, url: film_url)

      Image.create!(film_id: film.id, image_type: 'Poster',
                    remote_poster_url: remote_poster_url)

      li_nodes = film_doc.css('ul.showTimesListing li')
      showtimes_nodes = li_nodes.select do |showtime_node|
        showtime_node.content[' at:']
      end

      showtimes_nodes.each do |showtime_node|
        showing_date = showtime_node.css('strong').first.content
        showing_date.slice!(' at:')

        a_nodes = showtime_node.css('a')
        showing_time_nodes = a_nodes.select do |showing_time_node|
          showing_time_node.content.present?
        end

        showing_time_nodes.each do |showing_time_node|
          showtime = [showing_date, showing_time_node.content, 'EDT'].join(' ')
          film_showtime = DateTime.parse(showtime)

          Showing.find_or_create_by(film_id: film.id, theater_id: ifc.id,
                                    showtime: film_showtime)
        end
      end
    end
  end

  def scrape_ifc_coming_soon(ifc_coming_soon_url)
    ifc_coming_soon = Nokogiri::HTML(open(ifc_coming_soon_url))
    film_nodes = ifc_coming_soon.css('.wide_listing_right')

    film_nodes.each do |film_node|
      film_url = film_node.css('h3 a').first.attributes['href'].value

      scrape_ifc_doc(film_url)
    end

    a_nodes = ifc_coming_soon.css('.coming_soon_pagination.pagination-bottom a')

    next_node = a_nodes.select { |a| a.content['Next'] }

    if next_node.present?
      next_url = Theater.ifc_url(next_node.first.attributes['href'].value[1..-1])
      scrape_ifc_coming_soon(next_url)
    end
  end

  def scrape_ifc_now_playing(ifc_now_playing_url)
    ifc_now_playing = Nokogiri::HTML(open(ifc_now_playing_url))

    ifc_now_playing.css('.calendarListing li').each do |li_node|
      film_url = li_node.css('a').first.attributes['href'].value

      if URI.parse(film_url).host.downcase == URI.parse(Theater.ifc_url).host
        scrape_ifc_doc(film_url)
      end
    end
  end

  def scrape_imdb_poster(film_title)
    imdb_url = 'http://www.imdb.com'
    imdb_search_url = [imdb_url, '/find?q=', CGI::escape(film_title), '&s=all'].join
    imdb_search_results = Nokogiri::HTML(open(imdb_search_url))

    imdb_titles = imdb_search_results.css('h3').select do |h_node|
      h_node.content == 'Titles'
    end

    if imdb_titles.present?
      imdb_table = imdb_titles.first.next_sibling.next_sibling

      imdb_a_nodes = imdb_table.css('a').select do |a_node|
        a_node.content == film_title
      end

      if imdb_a_nodes.present?
        imdb_film_url = imdb_a_nodes.first.attributes['href'].value
        imdb_film_doc = Nokogiri::HTML(open([imdb_url, imdb_film_url].join))
        imdb_primary_img = imdb_film_doc.css('#img_primary')

        if imdb_primary_img.css('a').present?
          imdb_primary_img_url = imdb_primary_img.css('a').first.attributes['href'].value

          imdb_poster_doc = Nokogiri::HTML(open([imdb_url, imdb_primary_img_url].join))
          imdb_poster_doc.css('#primary-img').first.attributes['src'].value
        end
      end
    end
  end

  def scrape_angelika_doc(film_url)
    angelika_new_york = Theater.find_by_url(Theater.angelika_url)

    film_doc = Nokogiri::HTML(open(film_url))

    film_title = film_doc.css('.movieBlockHeader').first.content.titleize

    content_div = film_doc.css('#mainContent').first
    film_desc = content_div.css('span.contentText').first.content

    unless remote_poster_url = scrape_imdb_poster(film_title)
      img_src_url = film_doc.css('#movieDelivery img').first.attributes['src'].value
      remote_poster_url = Theater.angelika_url(img_src_url)
    end

    film = Film.find_or_create_by(title: film_title)
    film.update(description: film_desc, url: film_url)

    poster = Image.find_or_create_by(film_id: film.id, image_type: 'Poster')
    poster.update(remote_poster_url: remote_poster_url)

    showtimes_p_node = film_doc.css('p.contentText').first

    showtimes_span_nodes = showtimes_p_node.css('.movieBlockDate')

    showtimes_span_nodes.each_with_index do |showtime_span_node, index|
      if index - 1 < showtimes_span_nodes.size
        last_node = showtimes_p_node.children.last
      else
        last_node = showtime_span_nodes[index + 1]
      end

      nodes_between_span_nodes = nodes_between(showtime_span_node, last_node)
      a_nodes = nodes_between_span_nodes.select { |node| node.name == 'a' }
      a_nodes.each do |a_node|
        showtime_date = showtime_span_node.content
        showtime_date = Time.now.to_date.to_s if showtime_date.downcase == 'today'

        showtime = [showtime_date, a_node.content, 'EDT'].join(' ')
        film_showtime = DateTime.parse(showtime)

        Showing.find_or_create_by(film_id: film.id,
                                  theater_id: angelika_new_york.id,
                                  showtime: film_showtime)
      end
    end
  end

  def scrape_angelika_now_showing(angelika_now_showing_url)
    angelika_now_showing = Nokogiri::HTML(open(angelika_now_showing_url))

    dates = angelika_now_showing.css('.dropdownChooseDate option').map do |dropdown_option|
      dropdown_option.attributes['value'].value
    end

    dates.each do |date|
      date_now_showing_url = [angelika_now_showing_url, date].join('&rdate=')

      date_now_showing = Nokogiri::HTML(open(date_now_showing_url))

      date_now_showing.css('#movieBlock').each do |div_node|
        a_nodes = div_node.css('a.movieLink').select do |a_node|
          a_node.content =~ /MORE/
        end

        film_url = Theater.angelika_url(a_nodes.first.attributes['href'].value)

        scrape_angelika_doc(film_url)
      end
    end
  end

  def nodes_between(first, last)
    first == last ? [first] : [first, *nodes_between(first.next, last)]
  end
end
