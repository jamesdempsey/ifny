class Showing < ActiveRecord::Base
  belongs_to :film
  belongs_to :theater
end
