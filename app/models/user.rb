class User < ApplicationRecord
  has_secure_password validations: false

  validates_presence_of :email, :full_name, :password_digest
  validates_uniqueness_of :email

  has_many :queue_items
  has_many :reviews
end