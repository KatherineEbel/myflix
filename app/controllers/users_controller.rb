# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_user, only: :profile
  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(:email, :password, :full_name)
    if @user.save
      redirect_to sign_in_path
      flash[:success] = 'Registration completed, you can log in now.'
      UserMailer.with(user: @user).welcome_email.deliver_now
    else
      render :new
      flash[:danger] = 'Correct errors and try again.'
    end
  end

  def profile
    @user = User.find params[:id]
  end
end
