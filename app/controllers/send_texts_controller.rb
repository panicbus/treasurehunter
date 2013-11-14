class SendTextsController < ApplicationController

  def index
  end

  def make_message
    p params[:phone_number]
    phone_number = params[:phone_number]
    # respond_to do |format|
    #   format
    # end
    render text: 'Ok'
  end

end
