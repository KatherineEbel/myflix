class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.reviews.empty? ? "Review: N/A" : "Review: #{object.rating_average}/5.0"
  end
end