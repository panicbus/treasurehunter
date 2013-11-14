class HuntUsersController < ApplicationController
  def create
    @hunt_user = HuntUser.create(params[:hunt_user])
  end

<<<<<<< HEAD
  def confirm_participation
    pending_hunter = params[:hunt_user]
    user = User.find(pending_hunter['user_id'])
    hunt = Hunt.find(pending_hunter['hunt_id'])
    UserMailer.confirm_add_to_hunt(user, hunt).deliver

    # need a redirect to the huntmaster's show page
  end

  def store_hunter
    user = User.find(params[:id])
    hunt = Hunt.find(params[:hunt_id])
    hunt_user = HuntUser.create(role: 'hunter', progress: 0, hunt_id: hunt.id, user_id: user.id)
    if user_signed_in?
      redirect_to hunts_path
    else
      redirect_to new_user_session_path
    end
  end
end
=======
  def update
    @hunt_user = HuntUser.where(:hunt_id => params[:id], :user_id => current_user.id)

    @hunt_user.each do |hu|
      hu.update_attributes(progress: params[:progress])
    end
    respond_to do |format|
      format
    end
  end
end
>>>>>>> added a start button that only displays after the start time and updates the progress to 1 when clicked. also wired up the hunter screen to display current clue based on current progress, and to check if user answer is correct
