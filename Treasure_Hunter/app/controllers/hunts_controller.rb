class HuntsController < ApplicationController

  def index
    @hunts = Hunt.all
    @hunts.each do |h|
      h[:role] = HuntUser.find(h.id).role
    end

    respond_to do |format|
      format.html
      format.json { render json: @hunts }
    end
  end

  def show
    # Find the hunt
    @hunt = Hunt.find(params[:id])
    # Find the location ids for that hunt
    @location_ids = HuntLocation.find_all_by_hunt_id(1)
    @locations = []
    # Find locations based on location ids for that hunt and adding them to an array
    @location_ids.each do |location|
      @locations << Location.find(location.id)
    end
    # Finding clues for each location and adding them to the location hash
    @locations.each do |l|
      l[:clues] = Clue.find_by_location_id(l.id)
    end
    # Adding locations w/clues to the hunt
    @hunt[:loc] = @locations

    render json: @hunt
  end

  def create
    Hunt.create(params[:hunt])
    # redirect_to hunts_path
  end

  def destroy
    Hunt.destroy(params[:id])
    redirect_to hunts_path
  end

end
