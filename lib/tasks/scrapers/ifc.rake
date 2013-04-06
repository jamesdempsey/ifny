namespace :db do
  namespace :scrape do
    desc 'Scrape IFC Center'
    task ifc: :environment do
      require "#{Rails.root}/lib/scrapers"
      include Scrapers

      ifc_now_playing_url = Theater.ifc_url
      ifc_coming_soon_url = Theater.ifc_url('coming-soon/?viewmode=all')

      scrape_ifc_coming_soon(ifc_coming_soon_url)
      scrape_ifc_now_playing(ifc_now_playing_url)
    end
  end
end
