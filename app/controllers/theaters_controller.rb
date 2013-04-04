class TheatersController < ApplicationController
  respond_to :html, :json

  def index
    respond_with @theaters = Theater.all
  end

  def show
    respond_with @theater = Theater.find(params[:id])
  end
end
