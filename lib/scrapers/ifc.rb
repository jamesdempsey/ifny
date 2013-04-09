module Scrapers
  module Ifc
    include Scrapers::Helpers

    def scrape_ifc_now_playing(ifc_now_playing_url)
      ifc_now_playing = Nokogiri::HTML(open(ifc_now_playing_url))

      ifc_now_playing.css('.calendarListing li').each do |li_node|
        film_url = li_node.css('a').first.attributes['href'].value

        if URI.parse(film_url).host.downcase == URI.parse(Theater.ifc_url).host
          scrape_ifc_doc(film_url)
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

    def scrape_ifc_doc(film_url)
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

      film = find_or_create_film(film_title, film_desc, film_url, remote_poster_url)

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
          find_or_create_showing(showing_date, showing_time_node.content, film.id, ifc.id)
        end
      end

      if showtimes_nodes.empty?
        film.coming_soon = true
        film.save

        film_doc.css('.post strong').each do |strong_node|
          strong_node.content.scan(DATE).each do |date|
            find_or_create_showing(date.first, '12:00', film.id, ifc.id)
          end
        end
      else
        film.toggle!(:coming_soon) if film.coming_soon?
      end
    end
  end
end
