class Film < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings, -> { order 'showtime ASC' }
  has_many :theaters, -> { uniq true }, through: :showings
end
