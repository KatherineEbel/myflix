require 'rails_helper'

describe PaymentService do
  context 'given token' do
    let(:user_data) { Fabricate.attributes_for(:registration_candidate) }
    before do
      allow(StripeWrapper::Charge).to receive(:create)
                                        .and_return(StripeWrapper::Charge.new(StripeWrapper::Result.new('success', true)))
    end

    it 'should be successful' do
      result = PaymentService.new.process(user_data[:stripe_token])
      expect(result.success?).to be true
    end

    it 'should not have an error message' do
      result = PaymentService.new.process(user_data[:stripe_token])
      expect(result.error_message).to be_nil
    end
  end

  context 'given token is nil' do
    before do
      allow(StripeWrapper::Charge)
        .to receive(:create)
              .and_return(StripeWrapper::Charge
                            .new(StripeWrapper::Result
                                   .new('Some error', false)))
    end

    it 'should not be successful' do
      result = PaymentService.new.process(nil)
      expect(result.success?).to be false
    end

    it 'should have an error message' do
      result = PaymentService.new.process(nil)
      expect(result.error_message).to_not be_nil
    end
  end
end
