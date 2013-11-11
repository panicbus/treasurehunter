class LocationsController < ApplicationController

def new
end


def create
  Location.create(params[:location])
  redirect_to locations_path
end

def destroy
  Location.delete(params[:id])
  redirect_to locations_path
end

end
