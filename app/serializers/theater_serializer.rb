class TheaterSerializer < ActiveModel::Serializer
  attributes :id

  has_many :showings

  def showings
    object.showings.active
  end
end
