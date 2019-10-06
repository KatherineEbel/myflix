require 'rails_helper'
require 'ostruct'

describe CreateSignUp do
  describe '#call' do
    let(:create_customer) { class_double(CreateCustomer)}
    context 'valid user and credit card info' do
      let(:user) { User.new(Fabricate.attributes_for(:registration_candidate)) }
      before do
        allow(create_customer).to receive(:call)
        .with(user).and_return(OpenStruct.new(success?: true, error: nil))
      end

      it 'should charge the credit card' do
        result = CreateSignUp.call(user, create_customer)
        expect(result.success?).to be true
      end

      it 'should not have an error' do
        result = CreateSignUp.call(user, create_customer)
        expect(result.error).to be nil
      end
      it 'should send welcome email' do
        allow(UserMailer).to receive_message_chain(:with, :welcome_email, :deliver_later)
        CreateSignUp.call(user, create_customer)
        expect(UserMailer).to have_received(:with)
      end

      context 'given referral_id' do
        let(:friend) { Fabricate(:user) }
        before do
          user.referral_id = friend.id
        end
        it 'should add referrer to followed users' do
          CreateSignUp.call(user, create_customer)
          expect(user.followees).to include(friend)
        end

        it 'should add user to friends followed users' do
          CreateSignUp.call(user, create_customer)
          expect(friend.followees).to include(user)
        end
      end

      context 'given no referral_id' do
        let(:friend) { Fabricate(:user) }
        it 'should not add referrer to followed users' do
          CreateSignUp.call(user, create_customer)
          expect(user.followees).to_not include(friend)
        end

        it 'should not add user to friends followed users' do
          CreateSignUp.call(user, create_customer)
          expect(friend.followees).to_not include(user)
        end
      end
    end

    context 'valid user and invalid credit card info' do
      let(:user) { User.new(Fabricate.attributes_for(:user)) }
      before do
        allow(create_customer).to receive(:call)
                                    .with(user)
                                    .and_return(OpenStruct.new(success?: false, error: 'Invalid card info'))
      end

      it 'should not be successful' do
        result = CreateSignUp.call(user, create_customer)
        expect(result.success?).to be false
        expect(result.error).to_not be_nil
      end

      it 'should not add followees' do
        allow(User).to receive(:add_followees).with(user)
        friend = Fabricate(:user)
        user.referral_id = friend.id
        CreateSignUp.call(user, create_customer)
        expect(User).to_not have_received(:add_followees)
      end

      it 'should not save the user' do
        CreateSignUp.call(user, create_customer)
        expect(user.new_record?).to be true
      end

      it 'should not send the welcome email' do
        allow(UserMailer).to receive_message_chain(:with, :welcome_email, :deliver_now)
        CreateSignUp.call(user, create_customer)
        expect(UserMailer).to_not have_received(:with)
      end
    end

    context 'invalid user info and valid credit card info' do
      let(:user) { User.new(Fabricate.attributes_for(:registration_candidate)) }
      before do
        user[:email] = nil
        allow(create_customer).to receive(:call)
                                    .with(user)
                                    .and_return(OpenStruct.new(success?: false, error: 'Some error'))
      end
      it 'should not be successful' do
        result = CreateSignUp.call(user, create_customer)
        expect(result.success?).to be false
      end

      it 'should have an error message' do
        result = CreateSignUp.call(user, create_customer)
        expect(result.error).to_not be_nil
      end

      it 'should not save the user' do
        CreateSignUp.call(user, create_customer)
        expect(user.id).to be_nil
      end

      it 'should not send the welcome email' do
        allow(UserMailer).to receive_message_chain(:with, :welcome_email, :deliver_now)
        CreateSignUp.new(user, create_customer)
        expect(UserMailer).to_not have_received(:with)
      end

      it 'should not add followees' do
        allow(User).to receive(:add_followees).with(user)
        friend = Fabricate(:user)
        user.referral_id = friend.id
        CreateSignUp.call(user, create_customer)
        expect(User).to_not have_received(:add_followees)
      end
    end
  end

  describe '#send_welcome_email' do
    let(:user) { Fabricate(:user) }
    let(:create_customer) { class_double(CreateCustomer)}
    before do
      allow(create_customer).to receive(:call)
                                  .with(user).and_return(OpenStruct.new(success?: true, error: nil))
    end
    it 'should deliver email' do
      allow(UserMailer).to receive(:with).with({user: user })
      allow(UserMailer).to receive_message_chain(:with, :welcome_email, :deliver_later)
      service = CreateSignUp.new(user)
      service.send_welcome_email
      expect(UserMailer).to have_received(:with).with({ user: user })
    end
  end
end

