class User < ApplicationRecord
  include Tokenizable
  has_secure_password validations: false

  validates_presence_of :email, :full_name, :password_digest, :customer_id
  validates_uniqueness_of :email
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  has_many :followers, through: :following_users
  has_many :queue_items
  accepts_nested_attributes_for :queue_items
  has_many :reviews, -> { order('created_at DESC') }
  attr_accessor :referral_id, :stripe_token

  def self.add_followees(new_user)
    friend = User.find(new_user.referral_id)
    friend.follow! new_user
    new_user.follow! friend
  end

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

  def generate_password_token!
    generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (reset_password_sent_at + 1.hour) > Time.now.utc
  end
end
