# frozen_string_literal: true

# videos_controller
class VideosController < ApplicationController
  before_action :require_user
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title params[:query]
  end
end
