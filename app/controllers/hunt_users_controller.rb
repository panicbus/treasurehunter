class HuntUsersController < ApplicationController
  def create
    @hunt_user = HuntUser.create(params[:hunt_user])
  end

  def confirm_participation
    pending_hunter = params[:hunt_user]
    user = User.find(pending_hunter['user_id'])
    hunt = Hunt.find(pending_hunter['hunt_id'])
    UserMailer.confirm_add_to_hunt(user, hunt).deliver
    render text: 'ok'
    # need a redirect to the huntmaster's show page
  end

  def store_hunter
    user = User.find(params[:id])
    hunt = Hunt.find(params[:hunt_id])
    hunt_user = HuntUser.create(role: 'hunter', progress: 0, hunt_id: hunt.id, user_id: user.id)
    if signed_in?(user)
      redirect_to hunts_path
    else
        redirect_to new_user_session_path

    end
  end

  def update
    @hunt_user = HuntUser.where(:hunt_id => params[:id], :user_id => current_user.id)

    @hunt_user.each do |hu|
      hu.update_attributes(params[:progress])
    end
    render text: 'ok'
  end
end
