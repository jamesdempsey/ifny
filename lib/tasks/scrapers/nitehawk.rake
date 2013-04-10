namespace :db do
  namespace :scrape do
    desc 'Scrape Nitehawk Cinema'
    task nitehawk: :environment do
      include Scrapers::Nitehawk

      nitehawk_now_showing_url = Theater.nitehawk_url
      nitehawk_coming_soon_url = Theater.nitehawk_url('coming-soon/')

      scrape_nitehawk(nitehawk_now_showing_url)
      scrape_nitehawk(nitehawk_coming_soon_url)
    end
  end
end
