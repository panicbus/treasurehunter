class SendTextController < ApplicationController
  def index
  end

  def send_text_message
    number_to_send_to = params[:number_to_send_to]

    twilio_sid = "AC372b83858a96e1035d41c48ca368fa17"
    twilio_token = "16931672f9cfd3fd8b8aa87f7ac26f79"
    twilio_phone_number = "6504526730"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "You're getting warm! You're 100 feet away, #{number_to_send_to}"
    )
  end
end