class TheatersController < ApplicationController
  def index
    @theaters = Theater.all
  end

  def show
    @theater = Theater.find(params[:id])
    film = Film.find(params[:film_id])
    @showtimes = @theater.truncated_film_showtimes(film)
    render json: {theater: @theater, showtimes: @showtimes}
  end
end
