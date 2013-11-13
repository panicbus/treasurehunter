class UsersController < ApplicationController
  def show
    @user = User.find_by_username(params[:username])
    render json: @user
  end
end
