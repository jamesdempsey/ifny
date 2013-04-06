module Scrapers
  module Helpers
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

    def nodes_between(first, last)
      first == last ? [first] : [first, *nodes_between(first.next, last)]
    end
  end
end
