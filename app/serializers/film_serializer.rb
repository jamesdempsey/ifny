class FilmSerializer < ActiveModel::Serializer
  #embed :ids, include: true

  attributes :id, :showings_by_date

  #has_many :showings

  def showings_by_date
    showings = object.showings.active
    showtimes = showings.map { |showing| showing.showtime }

    mjd_showtimes = showtimes.inject({}) do |mjd_hash, datetime|
      mjd = datetime.to_date.mjd.to_s

      mjd_hash.has_key?(mjd) ? mjd_hash[mjd].push(datetime) : mjd_hash[mjd] = [datetime]

      mjd_hash
    end

    mjd_showtimes.inject([]) do |showtime_dates, mjd|
      datetimes = mjd[1]
      date_string = datetimes.first.strftime('%a, %b %-d at')

      showtime_date_string = datetimes.inject(date_string) do |showtime_date_str, datetime|
        datetime_string = datetime.strftime('%l:%M%P').strip
        [showtime_date_str, datetime_string].join(', ')
      end

      showtime_dates.push(showtime_date_string.gsub(/at,/, 'at'))
    end
  end
end
