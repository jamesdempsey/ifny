module ApplicationHelper
  def container_dimensions(image)
    width = image.width / 2
    height = image.height / 2
    ['width: ', width, 'px; height: ', height, 'px'].join
  end

  def theater_classes(film)
    film.theaters.map { |theater| Theater::URLS.key(theater.url) }.join(' ')
  end
end
