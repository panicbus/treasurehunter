class HuntLocationsController < ApplicationController
  def create
    HuntLocation.create(params[:hunt_loc])
  end
end
