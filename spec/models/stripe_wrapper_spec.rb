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
  context 'valid card data', :vcr do
    let(:card_number) { '4242424242424242' }
    it 'should be successful' do
      charge = StripeWrapper::Charge.create(token { card_number })
      expect(charge.successful?).to be true
    end
  end

  context 'invalid card data', :vcr do
    let(:card_number) { '4000000000000002' }
    it 'should not be successful' do
      charge = StripeWrapper::Charge.create(token { card_number })
      expect(charge.successful?).to be false
    end
  end
end
