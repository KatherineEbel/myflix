class Invite
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :friend_name, :friend_email, :message
  validates_presence_of :friend_name, :friend_email, :message
  validates_length_of :message, maximum: 400

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def id
    inviter_id
  end

  def persisted?
    false
  end
end