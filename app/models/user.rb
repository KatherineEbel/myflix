class User < ApplicationRecord
  has_secure_password validations: false

  validates_presence_of :email, :full_name, :password_digest
  validates_uniqueness_of :email

  has_many :queue_items
  accepts_nested_attributes_for :queue_items
  has_many :reviews

  def review_for(video)
    reviews.where(video: video).first
  end

  def queued?(video)
    !queue_items.find_by(video: video).nil?
  end

  def gravatar_url(size: 40)
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}?size=#{size}"
  end
end