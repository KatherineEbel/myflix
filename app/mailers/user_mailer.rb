class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to MyFlix!')
  end

  def forgot_password_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Link to Reset Your Password')
  end

  def invite_email
    @invite = params[:invite]
    @inviter = params[:inviter]
    mail(
      to: @invite.friend_email,
      subject: "Invitation to MyFlix from #{@inviter.full_name}"
    )
  end
end