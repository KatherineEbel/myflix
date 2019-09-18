class FollowsController < ApplicationController
  before_action :require_user
  def create
    followee = User.find params[:id]
    if current_user.following? followee
      flash[:danger] = "Error following #{followee.full_name}. Are you already following them?"
    else
      flash[:success] = "You are following #{followee.full_name}"
      current_user.follow! followee
    end
    redirect_back(fallback_location: profile_user_path(followee))
  end

  def show
    @followees = current_user.followees
  end

  def destroy
    if current_user.unfollow? User.find params[:id]
      flash[:success] = "User unfollowed"
    else
      flash[:warning] = 'Invalid request'
    end
    redirect_to people_path
  end
end
