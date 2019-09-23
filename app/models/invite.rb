class Invite
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :friend_name, :friend_email, :message
  validates_presence_of :friend_name, :friend_email, :message
  validates_length_of :message, maximum: 400

  def initialize(hash = {})
    self.attributes = hash
  end

  def attributes
    { 'friend_name': friend_name,
      'friend_email': friend_email,
      'message': message }
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def persisted?
    false
  end
end
