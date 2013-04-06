namespace :db do
  namespace :scrape do
    desc 'Scrape Angelika New York'
    task angelika: :environment do
      include Scrapers

      angelika_now_showing_url = Theater.angelika_url('angelika_index.asp?hID=1')

      scrape_angelika_now_showing(angelika_now_showing_url)
    end
  end
end
