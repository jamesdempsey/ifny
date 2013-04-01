class TheatersController < ApplicationController
  def index
    @theaters = Theater.all
  end

  def show
    @theater = Theater.find(params[:id])
    @showtimes = @theater.truncated_film_showtimes(params[:film_id].to_i)
    render json: {theater: @theater, showtimes: @showtimes}
  end
end
