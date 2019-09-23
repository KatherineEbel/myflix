module Tokenizable
  extend ActiveSupport::Concern

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless self.class.exists?(column => column)
    end
  end
end