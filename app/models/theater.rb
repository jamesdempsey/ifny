class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, through: :showings, uniq: true
end
