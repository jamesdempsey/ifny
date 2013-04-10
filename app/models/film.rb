class Film < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings, -> { order 'showtime ASC' }
  has_many :theaters, -> { uniq true }, through: :showings
  has_many :images

  scope :active, -> { joins(:showings).group('films.id').merge(Showing.active) }
  scope :by_title, lambda { |title| where("title ilike ?", "%#{title}%") }
end
