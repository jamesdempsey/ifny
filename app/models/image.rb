class Image < ActiveRecord::Base
  scope :posters, -> { where(image_type: 'Poster') }

  mount_uploader :poster, PosterUploader
end
