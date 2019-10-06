class CreateCustomer
  require 'ostruct'
  include Callable
  include StripeWrapper

  def initialize(user)
    @user = user
  end

  def call
    customer_created, error = create_customer
    if customer_created
      subscribed, error = subscribe_to_basic
      OpenStruct.new(success?: subscribed ? true : false,
                     error: error)
    else
      OpenStruct.new(success?: customer_created, error: error)
    end
  end

  private

  def create_customer
    result = Customer.create(@user)
    [result.success?, result.error]
  end

  def subscribe_to_basic
    throw Error.new('No customer id') if @user.customer_id.nil?
    result = Subscription.create(@user.customer_id)
    [result.success?, result.error]
  end
end