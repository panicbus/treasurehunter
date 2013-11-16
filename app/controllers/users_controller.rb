class UsersController < ApplicationController
  def index
    @users = User.all
    @users.each do |u|
      if current_user.id == u.id
        u[:current] = true
      end
    end
    render json: @users
  end

  def show
    @user = User.find_by_username(params[:username])
    render json: @user
  end
end
