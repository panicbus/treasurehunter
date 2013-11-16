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

    @locations.each do |l|
      l[:clues] = Clue.find_all_by_location_id(l.id)
    end

    render json: @locations
  end


  def create
    # p ('*') * 50
    # p params[:location][:name] && params[:location][:lat] && params[:location][:long]
    # if params[:location][:name] && params[:location][:lat] && params[:location][:long]
      @location = Location.create(params[:location])
    # end
    render json: @location
  end



  def destroy
    Location.delete(params[:id])
    redirect_to locations_path
  end

end
