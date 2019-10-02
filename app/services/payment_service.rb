class PaymentService
  Result = Struct.new(:success?, :error_message)
  def process(token)
    result = StripeWrapper::Charge.create(token)
    error_message = result.successful? ? nil : result.message
    Result.new(result.successful?, error_message)
  end
end