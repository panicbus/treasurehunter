class SendTextsController < ApplicationController

  def index
  end

  def make_message
    @user_phone_number = params[:user_phone_number]

    @phone_number = params[:phone_number]

  end

end
