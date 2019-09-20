class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to MyFlix!')
  end

  def forgot_password_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Link to Reset Your Password')
  end
end