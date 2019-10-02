class SignUpService
  def initialize(user, payment_handler: PaymentService.new)
    @user = user
    @payment_handler = payment_handler
  end

  def register
    result = @payment_handler.process(@user.stripe_token)
    if @user.valid? && result&.success?
      @user.save
      User.add_followees(@user) unless @user.referral_id.blank?
      send_welcome_email
    end
    result
  end

  def send_welcome_email
    UserMailer.with(user: @user).welcome_email.deliver_now
  end
end