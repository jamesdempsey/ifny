class Showing < ActiveRecord::Base
  belongs_to :film
  belongs_to :theater

  scope :by_theater, lambda { |theater| where(theater_id: theater.id) }
end
