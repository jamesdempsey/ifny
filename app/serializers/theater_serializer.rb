class TheaterSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :url

  has_many :showings
  has_many :films, through: :showings
end
