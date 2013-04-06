class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, -> { uniq true }, through: :showings

  URLS = {ifc: 'http://www.ifccenter.com/',
          angelika: 'http://www.angelikafilmcenter.com/'}

  URLS.keys.each do |url|
    define_singleton_method("#{url}_url".to_s) do |*url_strings|
      [URLS[url], *url_strings].join
    end
  end
end
