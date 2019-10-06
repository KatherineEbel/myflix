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
    result = CreateSignUp.call(@user)
    if result.success?
      redirect_to sign_in_path, flash: { success: 'Registration complete, you can sign in!'}
    else
      flash[:danger] = result.error
      render :new
    end
  end

  def profile
    @user = User.find params[:id]
  end
end
