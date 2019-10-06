module StripeWrapper
  require 'ostruct'
  class Result
    attr_reader :data, :success
    def initialize(data, success)
      @data = data
      @success = success
    end

  end
  class Charge
    def initialize(result)
      @result = result
    end

    def self.create(token)
      begin
        charge = Stripe::Charge.create({
                                amount: 999,
                                currency: 'usd',
                                description: 'MyFlix subscription',
                                source: token
                              })
        new(Result.new(charge.status, charge.paid))
      rescue Stripe::CardError => e
        new(Result.new(e.error.message, false))
      rescue Stripe::RateLimitError, Stripe::InvalidRequestError,
        Stripe::AuthenticationError, Stripe::APIConnectionError,
        Stripe::StripeError => e
        new(Result.new('Server error', false))
      rescue => e
        puts('Unknown error', e.inspect)
        new(Result.new('Ooops! Something went wrong. Let us know if problem persists',
                   false))
      end
    end

    def message
      @result.data
    end

    def successful?
      @result.success
    end
  end

  class Customer
    def self.create(user)
      begin
        customer = Stripe::Customer.create({
          email: user.email,
          source: user.stripe_token })
        user.update!(customer_id: customer.id)
        OpenStruct.new(success?: true, error: nil)
      rescue => e
        puts e
        OpenStruct.new(success?: false, error: e.message)
      end
    end
  end

  class Subscription
    def self.create(customer_id)
      begin
        subscription = Stripe::Subscription.create({
          customer: customer_id,
          items: [{ plan: 'plan_FvLaEBqzjQ9ZTR'}],
          expand: ['latest_invoice.payment_intent']})

        if subscription.latest_invoice.payment_intent.status.eql?('requires_payment_method')
          OpenStruct.new(success?: false, error: 'Problem billing your card, please provide a different one.')
        else
          OpenStruct.new(success?: true, error: nil)
        end
      rescue => e
        puts e
        OpenStruct.new(success?: false, error: e.message)
      end
    end
  end
end