class TextSendersController < ApplicationController

  def index
  end

  def send_text_message
    TextMessage.make_message(params[:user_phone_number])

    puts message.to
  end

end
