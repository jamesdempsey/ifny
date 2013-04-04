class FilmsController < ApplicationController
  respond_to :html, :json

  def index
    respond_with @films = Film.active
  end
end
