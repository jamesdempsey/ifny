require 'spec_helper'
include Scrapers::Helpers

describe Scrapers::Helpers do
  describe 'IMDB poster scraper' do
    it "should return the url of the film's poster image given the film's title" do
      scrape_imdb_poster('Citizen Kane').should eq 'http://ia.media-imdb.com/images/M/MV5BMTQ2Mjc1MDQwMl5BMl5BanBnXkFtZTcwNzUyOTUyMg@@._V1._SX338_SY500_.jpg'
    end

    it 'should do nothing for no search results' do
      scrape_imdb_poster('nilnil').should eq nil
    end
  end
end
