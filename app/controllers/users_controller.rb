# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(:email, :password, :full_name)
    if @user.save
      redirect_to sign_in_path
    else
      render :new
    end
  end
end
