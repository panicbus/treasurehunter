class LocationsController < ApplicationController

def index
  @locations = Location.all
end


def new
  @location = Location.new
end


def create
  Location.create(params[:location])
  redirect_to locations_path
end

def show
end

def destroy
  Location.delete(params[:id])
  redirect_to locations_path
end

end
