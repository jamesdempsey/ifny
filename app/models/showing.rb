class Showing < ActiveRecord::Base
  attr_accessible :film_id, :showtime, :theater_id

  belongs_to :film
  belongs_to :theater
end
