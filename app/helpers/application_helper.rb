module ApplicationHelper
  def container_dimensions(image)
    width = image.width / 2
    height = image.height / 2
    ['width: ', width, 'px; height: ', height, 'px'].join
  end
end
