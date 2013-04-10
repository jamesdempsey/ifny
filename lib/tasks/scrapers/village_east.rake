namespace :db do
  namespace :scrape do
    desc 'Scrape Village East Cinema'
    task village_east: :environment do
      include Scrapers::Angelika

      village_east_now_showing_url = Theater.village_east_url('angelika_index.asp?hID=166')
      village_east_coming_soon_url = Theater.village_east_url('angelika_comingSoon.asp?hID=166')

      scrape_angelika_now_showing(village_east_now_showing_url, theater: 'village_east')
      scrape_angelika_coming_soon(village_east_coming_soon_url, theater: 'village_east')
    end
  end
end
