# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_user, only: :profile

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new params
            .require(:user)
            .permit(:email, :password, :full_name, :referral_id, :stripe_token)
    unless @user.valid?
      flash[:danger] = 'There were problems with your registration information'
      render :new
      return
    end
    charge = StripeWrapper::Charge.create(@user.stripe_token)
    if charge.successful? && @user.save
      User.add_followees @user if @user.referral_id
      UserMailer.with(user: @user).welcome_email.deliver_now
      redirect_to sign_in_path, flash: { success: 'Registration complete, you can sign in!'}
    else
      flash[:danger] = charge.result.data
      render :new
    end
  end

  def profile
    @user = User.find params[:id]
  end
end
