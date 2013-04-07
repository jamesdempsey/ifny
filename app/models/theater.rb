class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, -> { uniq true }, through: :showings

  URLS = {ifc: 'http://www.ifccenter.com/',
          angelika: 'http://www.angelikafilmcenter.com/'}

  URLS.each do |theater, url|
    define_singleton_method("#{theater}_url") { |*url_strings| [url, *url_strings].join }
  end
end
