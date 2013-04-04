class FilmSerializer < ActiveModel::Serializer
  #embed :ids, include: true

  attributes :id

  has_many :showings

  def showings
    object.showings.active
  end
end
