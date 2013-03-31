module ApplicationHelper
  def container_dimensions(image)
    width = image.get_dimensions[:width] / 2
    height = image.get_dimensions[:height] / 2
    ['width: ', width, 'px; height: ', height, 'px'].join
  end
end
