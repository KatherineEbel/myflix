class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    @queue_item = QueueItem.new(video: video, user: current_user)
    if @queue_item.save
      flash[:info] = 'Video was added to your queue.'
      redirect_to my_queue_path
    else
      flash[:danger] = 'It looks like that video is already in your queue.'
      redirect_back(fallback_location: video_path(video))
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item.user == current_user
      queue_item.destroy
      QueueItem.normalize_priorities(current_user.queue_items)
      flash[:info] = 'Video was removed from you queue.'
    else
      flash[:danger] = 'Permission denied'
    end
    redirect_to my_queue_path
  end

  def update
    begin
      QueueItem
        .update_priorities(params.require(:user)[:queue_items_attributes],
                           current_user.id)
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
      flash[:danger] = 'Operation failed'
    end
    redirect_to my_queue_path
  end
end