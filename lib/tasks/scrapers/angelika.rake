namespace :db do
  namespace :scrape do
    desc 'Scrape Angelika New York'
    task angelika: :environment do
      require 'nokogiri'
      require 'open-uri'
      require 'cgi'
      require "#{Rails.root}/lib/scrapers"
      include Scrapers

      angelika_now_showing_url = 'http://www.angelikafilmcenter.com/angelika_nowshowing.asp?hID=1'

      scrape_angelika_now_showing(angelika_now_showing_url)
    end
  end
end
