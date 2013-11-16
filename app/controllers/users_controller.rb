class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find_by_username(params[:username])
    render json: @user
  end
end
