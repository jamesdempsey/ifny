class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, -> { uniq true }, through: :showings

  URLS = {ifc: 'http://www.ifccenter.com/',
          angelika: 'http://www.angelikafilmcenter.com/'}
end
