class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, -> { uniq true }, through: :showings

  ALL = {
          ifc: {
            name: 'IFC Center',
            url: 'http://www.ifccenter.com/'
          },
          angelika: {
            name: 'Angelika New York',
            url: 'http://www.angelikafilmcenter.com/'
          },
          village_east: {
            name: 'Village East Cinema',
            url: 'http://www.villageeastcinema.com/'
          },
          nitehawk: {
            name: 'Nitehawk Cinema',
            url: 'http://www.nitehawkcinema.com/'
          }
        }

  URLS.each do |theater, url|
    define_singleton_method("#{theater}_url") { |*url_strings| [url, *url_strings].join }
  end
end
