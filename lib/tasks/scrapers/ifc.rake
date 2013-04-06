namespace :db do
  namespace :scrape do
    desc 'Scrape IFC Center'
    task ifc: :environment do
      include Scrapers::Ifc

      ifc_now_playing_url = Theater.ifc_url
      ifc_coming_soon_url = Theater.ifc_url('coming-soon/?viewmode=all')

      scrape_ifc_now_playing(ifc_now_playing_url)
      scrape_ifc_coming_soon(ifc_coming_soon_url)
    end
  end
end
