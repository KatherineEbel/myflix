class PasswordsController < ApplicationController
  def create
    user = User.find_by_email(params.permit(:email_address)[:email_address])
    if user.present?
      user.generate_password_token!
      UserMailer.with(user: user).forgot_password_email.deliver_now
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to sign_in_path
    else
      flash[:warning] = 'Unable to locate your account'
      render :new
    end
  end

  def edit
    @user = User.find_by_reset_password_token(params[:reset_token])
  end

  def update
    @user = User.find_by_reset_password_token(params[:reset_token])
    @user.password = params[:password]
    if @user&.password_token_valid? && @user&.save
      redirect_to sign_in_path, flash: { success: 'Password updated' }
    else
      redirect_to new_password_path,
                  flash: { danger: 'Your reset password link is expired' }
    end
  end
end