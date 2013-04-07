module Scrapers
  module Angelika
    include Scrapers::Helpers

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

    def scrape_angelika_doc(film_url)
      angelika = Theater.find_by_url(Theater.angelika_url)

      film_doc = Nokogiri::HTML(open(film_url))

      film_title = film_doc.css('.movieBlockHeader').first.content.titleize

      content_div = film_doc.css('#mainContent').first
      film_desc = content_div.css('span.contentText').first.content

      unless remote_poster_url = scrape_imdb_poster(film_title)
        img_src_url = film_doc.css('#movieDelivery img').first.attributes['src'].value
        remote_poster_url = Theater.angelika_url(img_src_url)
      end

      film = find_or_create_film(film_title, film_desc, film_url, remote_poster_url)

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

          find_or_create_showing(showtime_date, a_node.content, film.id, angelika.id)
        end
      end
    end
  end
end
