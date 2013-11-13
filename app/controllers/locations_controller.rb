class LocationsController < ApplicationController
  def index

  end


  def show
    # Finding all the huntLocation entries with the current hunt id
    @location_ids = HuntLocation.find_all_by_hunt_id(params[:id])
    # Using the above entries to find all the locations associated with the current hunt
    @locations = []
    @location_ids.each do |l|
      @locations << Location.find(l.location_id)
    end

     render json: @locations
  end


  def create
    @location = Location.create(params[:location])
    render json: @location
  end



  def destroy
    Location.delete(params[:id])
    redirect_to locations_path
  end

end
