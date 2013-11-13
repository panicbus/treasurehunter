class HuntUsersController < ApplicationController
  def create
    @hunt_user = HuntUser.create(params[:hunt_user])
  end
end
