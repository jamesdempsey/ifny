module Scrapers
  module Helpers
    days = "((#{%w(Monday Tuesday Wednesday Thursday Friday
              Saturday Sunday).join('|')})"
    months = "(#{%w(January February March April May June July August
                September October November December).join('|')})"
    IFC_DATE_REGEXP = Regexp.new("#{days}, #{months} " + '\d{1,2})')
    ANGELIKA_DATE_REGEXP = Regexp.new("(#{months} " + '\d{1,2}, \d{4})',
                                     Regexp::IGNORECASE)

    def scrape_imdb_poster(film_title)
      search_results = nokogiri imdb_query_url(film_title)

      titles = search_results.select_by_content(:h3, 'Titles')

      if titles.present?
        table = titles.first.next_sibling.next_sibling
        film_link = table.select_by_content(:a, film_title)

        if film_link.present?
          film_url = film_link.node_href
          imdb_film_doc = nokogiri imdb_url(film_url)
          imdb_primary_img = imdb_film_doc.css('#img_primary')

          if imdb_primary_img.css('a').present?
            img_url = imdb_primary_img.css('a').node_href

            imdb_poster_doc = nokogiri imdb_url(img_url)
            imdb_poster_doc.css('#primary-img').node_src
          end
        end
      end
    end

    def nodes_between(first, last)
      first == last ? [first] : [first, *nodes_between(first.next, last)]
    end

    def find_or_create_film(film_title, film_desc, film_url, remote_poster_url)
      film = Film.find_or_create_by(title: film_title)
      film.update(description: film_desc) unless film_desc == film.description
      film.update(url: film_url) unless film_url == film.url

      image = Image.find_or_create_by(film_id: film.id, image_type: 'Poster')
      image.update(remote_poster_url: remote_poster_url) unless image.poster?

      film
    end

    def find_or_create_showing(date, time, film_id, theater_id)
      showtime = [date, time, 'EDT'].join(' ')
      film_showtime = DateTime.parse(showtime)

      Showing.find_or_create_by(film_id: film_id, theater_id: theater_id, showtime: film_showtime)
    end

    protected

      def select_by_content(tag, content)
        self.css(tag.to_s).select { |node| node.content == content }
      end

      def node_href
        self.first.attributes['href'].value
      end

      def node_src
        self.first.attributes['src'].value
      end

    private

      def nokogiri(url)
        Nokogiri::HTML open(url)
      end

      def imdb_url(url)
        'http://www.imdb.com' + url
      end

      def imdb_query_url(film_title)
        imdb_url '/find?q=' + CGI::escape(film_title) + '&s=all'
      end
  end
end
