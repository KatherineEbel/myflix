class InvitesController < ApplicationController
  before_action :require_user

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(params.require(:invite)
                           .permit(
                             :friend_name, :friend_email,
                             :message
                           ))
    if @invite.valid?
      UserMailer.with(invite: @invite, inviter: current_user).invite_email.deliver_now
      redirect_to people_path,
                  flash: { success: 'Your Invitation has been sent.' }
    else
      render :new, flash: { danger: 'Please correct errors and try again' }
    end
  end
end
