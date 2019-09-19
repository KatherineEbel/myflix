# frozen_string_literal: true

# sessions_controller.rb
class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to home_path, flash: { info: "Welcome back #{user.full_name}" }
    else
      flash[:danger] = 'There was a problem with your email/and or password'
      render :new
    end
  end

  def destroy
    redirect_to sign_in_path if session[:current_user_id].nil?

    user = User.find_by_id session[:current_user_id]
    session[:current_user_id] = nil
    redirect_to sign_in_path flash: {
      info: "See you next time #{user.full_name}!"
    }
  end
end
