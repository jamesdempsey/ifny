class Film < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings, order: 'showtime ASC'
  has_many :theaters, through: :showings, uniq: true
end
