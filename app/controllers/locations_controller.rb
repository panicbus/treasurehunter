class LocationsController < ApplicationController

def index
  @locations = Location.all
end


def new
  @location = Location.new
end


def create
  @location = Location.create(params[:location])
  @location[:hunt] = 1

  render json: @location
end

def show
end

def destroy
  Location.delete(params[:id])
  redirect_to locations_path
end

end
