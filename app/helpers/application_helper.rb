module ApplicationHelper
  def container_dimensions(image)
    width = image.width / 2
    height = image.height / 2
    ['width: ', width, 'px; height: ', height, 'px'].join
  end

  def theater_classes(film)
    classes = film.theaters.map do |theater|
      hash = {name: theater.name, url: theater.url}
      Theater::ALL.key(hash)
    end

    classes.join(' ')
  end

  def theater_class(theater)
    Theater::ALL.key({name: theater.name, url: theater.url})
  end
end
