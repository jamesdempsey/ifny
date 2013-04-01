class Theater < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :showings
  has_many :films, -> { uniq true }, through: :showings

  def film_showtimes(film_id)
    film_showings = showings.select { |showing| showing.film_id == film_id }
    film_showtimes = film_showings.map { |showing| showing.showtime }

    mjd_showtimes = film_showtimes.inject({}) do |mjd_hash, datetime|
      mjd = datetime.to_date.mjd.to_s

      if mjd_hash.has_key?(mjd)
        mjd_hash[mjd].push(datetime)
      else
        mjd_hash[mjd] = [datetime]
      end

      mjd_hash
    end

    mjd_showtimes.inject([]) do |showtime_dates, mjd|
      datetimes = mjd[1]
      date_string = datetimes.first.strftime('%a, %b %-d at')

      showtime_date_string = datetimes.inject(date_string) do |showtime_date_s, datetime|
        datetime_string = datetime.strftime('%l:%M%P').strip
        [showtime_date_s, datetime_string].join(', ')
      end

      showtime_dates.push(showtime_date_string.gsub(/at,/, 'at'))
    end
  end

  def truncated_film_showtimes(film_id)
    film_showtimes = film_showtimes(film_id)

    truncated = []

    truncated_film_showtimes = film_showtimes.take_while do |showtime|
      truncated.push(showtime)
      truncated.join.length <= 230
    end

    if film_showtimes.size != truncated_film_showtimes.size
      truncated_film_showtimes.push('...more')
    else
      truncated_film_showtimes
    end
  end
end
