class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, -> { uniq true }, through: :showings
end
