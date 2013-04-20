require 'spec_helper'

describe Theater do
  describe 'name constants' do
    let(:theater_name) do
      ->(theater) { Theater::ALL[theater][:name] }
    end

    it 'should have IFC Center' do
      theater_name.call(:ifc).should eq 'IFC Center'
    end

    it 'should have Angelika New York' do
      theater_name.call(:angelika).should eq 'Angelika New York'
    end

    it 'should have Village East Cinema' do
      theater_name.call(:village_east).should eq 'Village East Cinema'
    end

    it 'should have Nitehawk Cinema' do
      theater_name.call(:nitehawk).should eq 'Nitehawk Cinema'
    end

    it 'should have the Film Society of Lincoln Center' do
      theater_name.call(:lincoln_center).should eq 'The Film Society of Lincoln Center'
    end
  end

  describe 'URL methods' do
    it 'should have IFC Center' do
      Theater.ifc_url.should eq 'http://www.ifccenter.com/'
    end

    it 'should have Angelika New York' do
      Theater.angelika_url.should eq 'http://www.angelikafilmcenter.com/'
    end

    it 'should have Village East Cinema' do
      Theater.village_east_url.should eq 'http://www.villageeastcinema.com/'
    end

    it 'should have IFC Center' do
      Theater.nitehawk_url.should eq 'http://www.nitehawkcinema.com/'
    end

    it 'should have the Film Society of Lincoln Center' do
      Theater.lincoln_center_url.should eq 'http://www.filmlinc.com/'
    end
  end
end
