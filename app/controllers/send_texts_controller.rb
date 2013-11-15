class SendTextsController < ApplicationController
  require 'twilio-ruby'
  def index
    self.make_message(params[:phone_number], params[:body])
  end

  def make_message(phone_number, body)

    account_sid = 'AC372b83858a96e1035d41c48ca368fa17'
    auth_token = '16931672f9cfd3fd8b8aa87f7ac26f79'
    twilio_phone_number = ""

    client = Twilio::REST::Client.new account_sid, auth_token

    #the @client initializes a helper library that will be able to receive and send messages
    #the @client will communicate with twilio's REST API (talks to the twilio server to send messages)

    account = client.account
    message = account.sms.messages.create({
      :from => "+16504526730",
      :to => phone_number,
      :body => body
      })
      puts "Sent message."

    render text: 'ok'
  end

end
