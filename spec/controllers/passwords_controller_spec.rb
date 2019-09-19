require 'rails_helper'

describe PasswordsController do
  describe 'POST #create' do
    context 'user is registered' do
      let(:user) { Fabricate(:user) }
      before do
        post :create, params: { email_address: user.email }
      end

      it { should permit(:email_address).for(:create) }

      it 'should generate a password token for user' do
        expect(user.reload.reset_password_token).to_not be_nil
      end

      it { should redirect_to sign_in_path }
      context 'forgot_password_email' do
        it 'should send an email' do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'should be sent to the correct recipient' do
          email = ActionMailer::Base.deliveries.last
          expect(email.to.first).to eq user.email
        end

        it 'should contain a password reset token with to reset password' do
          email = ActionMailer::Base.deliveries.last
          expect(email.body).to include user.reset_password_token
        end
      end
      it_behaves_like 'flash[:info] message'
    end

    context 'user is not registered' do
      before do
        post :create, params: { email_address: 'wrong@example.com' }
      end

      it { should permit(:email_address).for(:create) }
      it { should render_template :new }
      it_behaves_like 'flash[:warning] message'
    end
  end

  describe 'GET #edit' do
    let(:user) { Fabricate(:user) }
    before do
      post :create, params: { email_address: user.email }
      get :edit, params: { reset_token: user.reload.reset_password_token }
    end
    it 'should set @user' do
      expect(assigns(:user)).to eq user
    end
  end

  describe 'PATCH #update' do
    let(:user) { Fabricate(:user) }
    before do
      post :create, params: { email_address: user.email }
    end
    context 'valid reset token' do
      before do
        patch :update, params:
          { reset_token: user.reload.reset_password_token,
            password: 'newpassword' }
      end
      it 'should set @user' do
        expect(assigns(:user)).to eq user
      end

      it_behaves_like 'flash[:success] message'
      it { should redirect_to sign_in_path }
    end

    context 'invalid reset token' do
      before do
        user.update!(reset_password_sent_at: 4.hours.ago)
        patch :update, params:
          { reset_token: user.reload.reset_password_token,
            password: 'newpassword' }
      end

      it { should redirect_to new_password_path }
      it_behaves_like 'flash[:danger] message'
    end
  end
end
