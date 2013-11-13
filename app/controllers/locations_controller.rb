class LocationsController < ApplicationController

def show
  @location_ids = HuntLocation.find_all_by_hunt_id(params[:id])
  @locations = []

  @location_ids.each do |l|
    @locations << Location.find(l.location_id)
  end

   render json: @locations
end


def create
  @location = Location.create(params[:location])
  @location[:hunt] = 1

  render json: @location
end



def destroy
  Location.delete(params[:id])
  redirect_to locations_path
end

end
