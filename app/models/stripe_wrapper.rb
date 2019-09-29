module StripeWrapper
  class Result
    attr_reader :data, :success
    def initialize(data, success)
      @data = data
      @success = success
    end

  end
  class Charge
    attr_reader :result
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

    def successful?
      result.success
    end
  end
end