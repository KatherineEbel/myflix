class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @review = Review.new(params.require(:review)
                           .permit(:rating, :text))
    @review.video = Video.find(params[:video_id])
    @review.reviewer = current_user
    if @review.save
      redirect_to video_path @review.video
      flash[:info] = 'Your review was added'
    else
      flash[:danger] = 'Your review could not be saved.'
      render 'videos/show'
    end
  end
end