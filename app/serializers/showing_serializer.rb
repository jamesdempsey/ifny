class ShowingSerializer < ActiveModel::Serializer
  attributes :id, :theater_id, :showtime

  def showtime
    object.showtime_string
  end
end
