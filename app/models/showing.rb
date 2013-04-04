class Showing < ActiveRecord::Base
  belongs_to :film
  belongs_to :theater

  scope :by_theater, lambda { |theater| where(theater_id: theater.id) }
  scope :active, -> { where('showtime >= ?', Time.now - 1.day) }

  def showtime_string
    [showtime.strftime('%a, %b %-d at'), showtime.strftime('%l:%M%P').strip].join(' ')
  end
end
