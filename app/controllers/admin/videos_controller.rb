class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video
      .new(params
             .require(:video)
             .permit(:description, :large_cover_url,
                     :small_cover_url, :title))
    category = Category.find(params[:video][:category_id])
    @video.category = category

    if @video.save
      redirect_to new_admin_video_path, flash: { success: 'Video added' }
    else
      flash[:danger] = 'Please correct form errors'
      render :new
    end
  end
end