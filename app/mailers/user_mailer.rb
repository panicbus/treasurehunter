class UserMailer < ActionMailer::Base
  default from: "treasurehunterrailsapp@gmail.com"

  def confirm_add_to_hunt(current_user, hunt)
    @current_user = current_user
    @hunt = hunt
    mail(to: @current_user.email, subject: 'TreasureHunter: You are invited to a hunting party!')
  end
end