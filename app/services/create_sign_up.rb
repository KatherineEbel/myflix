class CreateSignUp
  require 'ostruct'
  include Callable


  def initialize(user, customer_service = CreateCustomer)
    @user             = user
    @customer_service = customer_service
  end

  def call
    result = @customer_service.call(@user)
    if result.success? && @user.valid?
      @user.save
      User.add_followees(@user) unless @user.referral_id.blank?
      send_welcome_email
      OpenStruct.new(success?: true, error: result.error)
    else
      OpenStruct.new(success?: false, error: result.error)
    end
  end

  def send_welcome_email
    UserMailer.with(user: @user).welcome_email.deliver_later
  end
end