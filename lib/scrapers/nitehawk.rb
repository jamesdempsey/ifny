module Scrapers
  module Nitehawk
    include Scrapers::Helpers

    def scrape_nitehawk(nitehawk_now_playing_url)
      nitehawk_now_playing = Nokogiri::HTML(open(nitehawk_now_playing_url))

      nitehawk_now_playing.css('.movie-list > li').each do |li_node|
        film_url_node = li_node.css('h2 a').first
        film_url = film_url_node.attributes['href'].value
        film_title = film_url_node.content.downcase

        if URI.parse(film_url).host.downcase == URI.parse(Theater.nitehawk_url).host
          scrape_nitehawk_doc(film_url) unless film_title == 'five dollar film club'
        end
      end
    end

    def scrape_nitehawk_doc(film_url)
      nitehawk = Theater.find_by_url(Theater.nitehawk_url)

      film_doc = Nokogiri::HTML(open(film_url))

      film_title = film_doc.css('.page-title').first.content.titleize

      p_nodes = film_doc.css('.two_third p').select do |p_node|
        p_node.content.split.size > 10
      end

      film_desc = p_nodes.join

      unless remote_poster_url = scrape_imdb_poster(film_title)
        remote_poster_url = film_doc.css('.poster-image-medium img').first.attributes['src'].value
      end

      film = find_or_create_film(film_title, film_desc, film_url, remote_poster_url)

      film_doc.css('.showtime-links > li').each do |li_node|
        showing_date = li_node.attributes['id'].value.delete('-')

        li_node.css('li').each do |showtime_li_node|
          a_node = showtime_li_node.css('a')
          showing_time = a_node.present? ? a_node.first.content : showtime_li_node.content

          find_or_create_showing(showing_date, showing_time, film.id, nitehawk.id)
        end
      end
    end
  end
end
