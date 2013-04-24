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

  describe 'nodes_between helper' do
    before do
      VCR.use_cassette('angelika') do
        url = 'http://www.angelikafilmcenter.com/angelika_film.asp?hID=1&ID=i361evp.2v104610dmyx03913x.33'
        response = Net::HTTP.get_response(URI(url))
        doc = Nokogiri::HTML response.body
        parent = doc.css('p.contentText').first
        first = parent.css('.movieBlockDate').first
        last = parent.css('.movieBlockDate')[1]
        nodes = nodes_between(first, last)
        @content = nodes.map(&:content)
      end
    end

    it 'should return all the nodes between two nodes' do
      showtimes = %w(12:40\ PM  1:40\ PM  2:20\ PM  4:00\ PM  4:40\ PM  6:20\ PM  7:00\ PM  8:40\ PM  9:20\ PM  10:00\ PM)
      @content.should include(*showtimes)
    end

    it 'should return only nodes between two nodes' do
      @content.should_not include '11:20 AM', '12:00 PM'
    end
  end

  describe 'find_or_create_film helper' do
    it 'should something' do
      pending 'something'
    end
  end
end
