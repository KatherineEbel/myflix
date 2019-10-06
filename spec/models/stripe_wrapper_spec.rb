require 'rails_helper'

describe 'StripeWrapper', :vcr do
  let(:token) do
    Stripe::Token.create({
                           card: {
                             number: card_number,
                             exp_month: 9,
                             exp_year: 2020,
                             cvc: '314',
                           },
                         }).id
  end
  describe 'StripeWrapper::Charge' do
    context 'valid card data', :vcr do
      let(:card_number) { '4242424242424242' }
      it 'should be successful' do
        charge = StripeWrapper::Charge.create(token { card_number })
        expect(charge.successful?).to be true
      end
    end

    context 'invalid card data' do
      let(:card_number) { '4000000000000002' }
      it 'should not be successful' do
        charge = StripeWrapper::Charge.create(token { card_number })
        expect(charge.successful?).to be false
      end
    end

  end

  describe 'StripeWrapper::Customer' do
    let(:user) { User.new(Fabricate.attributes_for(:user)) }
    context 'valid card data', :vcr do
      let(:card_number) { '4242424242424242' }
      it 'should be successful' do
        user.stripe_token = token { card_number }
        result = StripeWrapper::Customer.create(user)
        expect(result).to be_success
      end
    end

    context 'invalid card data' do
      let(:card_number) { '4000000000000002' }
      it 'should not be successful' do
        user.stripe_token = token { card_number }
        result = StripeWrapper::Customer.create(user)
        expect(result).to_not be_success
      end

      it 'should return an error message' do
        user.stripe_token = token { card_number }
        result = StripeWrapper::Customer.create(user)
        expect(result.error).to_not be_nil
      end
    end

  end

  describe 'StripeWrapper::Subscription' do
    let(:user) { User.new(Fabricate.attributes_for(:user)) }
    context 'valid card' do
      let(:card_number) { '4242424242424242' }
      it 'should be successful' do
        user = User.new(Fabricate.attributes_for(:user))
        user.stripe_token = token { card_number }
        StripeWrapper::Customer.create(user)
        result = StripeWrapper::Subscription.create(user.customer_id)
        expect(result).to be_success
      end
    end

    context 'charge fails' do
      let(:user) { User.new(Fabricate.attributes_for(:user)) }
      let(:card_number) { '4000000000000341'}
      it 'should not be successful' do
        user = User.new(Fabricate.attributes_for(:user))
        user.stripe_token = token { card_number }
        StripeWrapper::Customer.create(user)
        result = StripeWrapper::Subscription.create(user)
        expect(result).to_not be_success
        expect(result.error).to_not be_nil
      end

    end
  end
end
