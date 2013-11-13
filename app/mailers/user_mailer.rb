class UserMailer < ActionMailer::Base
  default from: "treasurehunterrailsapp@gmail.com"

  def test_email(current_user)
    @current_user = current_user
    mail(to: @current_user.email, subject: 'Test message')
  end
end
