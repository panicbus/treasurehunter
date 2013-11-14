class SendTextsController < ApplicationController

  def index
  end

  def make_message
    @phone_number = params[:phone_number]

  end

end
