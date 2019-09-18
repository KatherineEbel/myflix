class User < ApplicationRecord
  has_secure_password validations: false

  validates_presence_of :email, :full_name, :password_digest
  validates_uniqueness_of :email
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :following_users
  has_many :queue_items
  accepts_nested_attributes_for :queue_items
  has_many :reviews, -> { order('created_at DESC') }

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

  def can_follow?(other_user)
    !other_user.eql?(self) && !following?(other_user)
  end

  def follow!(other_user)
    followees << other_user
  end

  def following?(other_user)
    followees.include? other_user
  end

  def unfollow?(other_user)
    followed_users.destroy_by(follower_id: self, followee_id: other_user)
                  .first&.followee.eql?(other_user) || false
  end
end
