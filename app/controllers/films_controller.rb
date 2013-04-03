class FilmsController < ApplicationController
  def index
    @films = Film.active
  end
end
