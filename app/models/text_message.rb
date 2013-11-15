class TextMessage < ActiveRecord::Base
  attr_accessible :user_phone_number

  def make_message(phone_number)

    account_sid = 'AC372b83858a96e1035d41c48ca368fa17'
    auth_token = '16931672f9cfd3fd8b8aa87f7ac26f79'
    twilio_phone_number = "6504526730"

    client = Twilio::REST::Client.new account_sid, auth_token

    #the @client initializes a helper library that will be able to receive and send messages
    #the @client will communicate with twilio's REST API (talks to the twilio server to send messages)

    account = client.account
    message = account.sms.messages.create({
      :from => "+1#{twilio_phone_number}",
      :to => phone_number,
      :body => "You're getting warm! You're less than 100 feet away!"
      })
      puts "Sent message."
  end

end
