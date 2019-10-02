require 'rails_helper'

describe SignUpService do
  describe '#register' do
    Result = Struct.new(:success?, :user_id, :error_message)
    let(:payment_handler) { instance_double('PaymentService') }
    context 'valid user and credit card info' do
      let(:user) { User.new(Fabricate.attributes_for(:registration_candidate)) }
      before do
        allow(payment_handler).to receive(:process)
                                    .with(user.stripe_token)
                                    .and_return(Result.new(true, 1, nil))
      end
      it 'should return the user id' do
        result = SignUpService.new(user, payment_handler: payment_handler).register
        expect(result.user_id).to_not be_nil
        expect {
          User.find(result.user_id)
        }.to_not raise_error
      end
      it 'should charge the credit card' do
        result = SignUpService.new(user, payment_handler: payment_handler).register
        expect(result.success?).to be true
      end
      it 'should send welcome email' do
        service = SignUpService.new(user, payment_handler: payment_handler)
        allow(service).to receive(:send_welcome_email)
        service.register
        expect(service).to have_received(:send_welcome_email)
      end

      context 'given referral_id' do
        let(:friend) { Fabricate(:user) }
        before do
          user.referral_id = friend.id
        end
        it 'should add referrer to followed users' do
          SignUpService.new(user, payment_handler: payment_handler).register
          expect(user.followees).to include(friend)
        end

        it 'should add user to friends followed users' do
          SignUpService.new(user, payment_handler: payment_handler).register
          expect(friend.followees).to include(user)
        end
      end

      context 'given no referral_id' do
        let(:friend) { Fabricate(:user) }
        it 'should not add referrer to followed users' do
          SignUpService.new(user, payment_handler: payment_handler).register
          expect(user.followees).to_not include(friend)
        end

        it 'should not add user to friends followed users' do
          SignUpService.new(user, payment_handler: payment_handler).register
          expect(friend.followees).to_not include(user)
        end
      end
    end

    context 'valid user and invalid credit card info' do
      let(:user) { User.new(Fabricate.attributes_for(:user)) }
      before do
        allow(payment_handler).to receive(:process)
                                    .with(user.stripe_token)
                                    .and_return(Result.new(false, nil, 'Invalid card info'))
      end
      it 'should not be successful' do
        result = SignUpService.new(user, payment_handler: payment_handler).register
        expect(result.success?).to be false
        expect(result.error_message).to_not be_nil
      end
      it 'should not add followees' do
        allow(User).to receive(:add_followees).with(user)
        friend = Fabricate(:user)
        user.referral_id = friend.id
        SignUpService.new(user, payment_handler: payment_handler).register
        expect(User).to_not have_received(:add_followees)
      end
      it 'should not save the user' do
        SignUpService.new(user, payment_handler: payment_handler).register
        expect(user.new_record?).to be true
      end

      it 'should not send the welcome email' do
        service = SignUpService.new(user, payment_handler: payment_handler)
        allow(service).to receive(:send_welcome_email)
        service.register
        expect(service).to_not have_received(:send_welcome_email)
      end
    end

    context 'invalid user info and valid credit card info' do
      let(:user) { User.new(Fabricate.attributes_for(:registration_candidate)) }
      before do
        user[:email] = nil
        allow(payment_handler).to receive(:process)
                                    .with(user.stripe_token)
                                    .and_return(Result.new(false, nil, 'Invalid user'))
      end
      it 'should not be successful' do
        result = SignUpService.new(user, payment_handler: payment_handler).register
        expect(result.success?).to be false
      end

      it 'should have an error message' do
        result = SignUpService.new(user, payment_handler: payment_handler).register
        expect(result.error_message).to_not be_nil
      end

      it 'should not save the user' do
        result = SignUpService.new(user, payment_handler: payment_handler).register
        expect(result.user_id).to be_nil
        expect(user.id).to be_nil
      end

      it 'should not send the welcome email' do
        service = SignUpService.new(user, payment_handler: payment_handler)
        allow(service).to receive(:send_welcome_email)
        service.register
        expect(service).to_not have_received(:send_welcome_email)
      end

      it 'should not add followees' do
        allow(User).to receive(:add_followees).with(user)
        friend = Fabricate(:user)
        user.referral_id = friend.id
        SignUpService.new(user, payment_handler: payment_handler).register
        expect(User).to_not have_received(:add_followees)
      end
    end
  end
end

