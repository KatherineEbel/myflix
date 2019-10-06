require 'rails_helper'

describe CreateCustomer do
  let(:user) { User.new Fabricate.attributes_for(:registration_candidate) }
  context 'given token' do
    before do
      allow(StripeWrapper::Customer).to receive(:create)
                                        .and_return(OpenStruct.new(success?: true, error: nil))
      allow(StripeWrapper::Subscription).to receive(:create)
                                              .and_return(OpenStruct.new(success?: true, error: nil))
    end

    it 'should be successful' do
      result = CreateCustomer.call(user)
      expect(result.success?).to be true
    end

    it 'should not have an error message' do
      result = CreateCustomer.call(user)
      expect(result.error).to be_nil
    end
  end

  context 'given token is nil' do
    before do
      user.stripe_token = nil
      allow(StripeWrapper::Customer)
        .to receive(:create)
              .and_return(OpenStruct.new(success?: false, error: 'Some error'))
    end

    it 'should not be successful' do
      result = CreateCustomer.call(user)
      expect(result.success?).to be false
    end

    it 'should have an error message' do
      result = CreateCustomer.call(user)
      expect(result.error).to_not be_nil
    end
  end
end
