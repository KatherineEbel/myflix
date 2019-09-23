class InviteEmailWorker
  include Sidekiq::Worker

  def perform(invite, inviter_id)
    invitation = Invite.new.from_json(invite)
    inviter = User.find(inviter_id)
    UserMailer.with(invite: invitation, inviter: inviter).invite_email.deliver
  end
end