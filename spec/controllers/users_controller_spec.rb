require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #new' do
    context 'logged in user' do
      it 'should redirect to home_path' do
        get :new, session: { current_user_id: Fabricate(:user).to_param }
        expect(response).to redirect_to home_path
      end
    end
    context 'user not logged in' do
      it 'should set @user' do
        get :new
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:user)).to be_instance_of(User)
      end
      it 'should render new template' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    context 'valid form' do
      let(:user_data) { Fabricate.attributes_for(:user) }
      before do
        allow(StripeWrapper::Charge)
          .to receive(:create)
                .and_return(StripeWrapper::Charge.new(StripeWrapper::Result.new('success', true)))
        post :create,
             params: { user: user_data }
      end

      it 'should set @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'should create the user' do
        user = User.find_by_email(user_data[:email])
        expect(user).to_not be_nil
        expect(user.full_name).to eq user_data[:full_name]
      end

      context 'welcome_email' do
        it 'should send the email' do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it 'should send to the correct recipient' do
          expect(ActionMailer::Base.deliveries.last.to.first).to eq user_data[:email]
        end

        it 'should have the right content' do
          mail = ActionMailer::Base.deliveries.last
          # expect(content).to include user_data[:full_name]
          expect(mail.subject).to include 'Welcome to MyFlix'
          expect(mail.text_part.body.to_s).to include user_data[:full_name]
          expect(mail.text_part.body.to_s).to include 'Welcome to MyFlix'
        end
      end

      it 'should should redirect to sign_in_path' do
        expect(response).to redirect_to sign_in_path
      end

      it_behaves_like 'flash[:success] message'
    end

    context 'invalid form' do
      before do
        User.destroy_all
        allow(StripeWrapper::Charge)
          .to receive(:create)
                .and_return(StripeWrapper::Charge
                              .new(StripeWrapper::Result
                                     .new('Some error', false)))
        post :create, params: {
          user: {
            email: '',
            password: '',
            full_name: ''
          }
        }
      end

      it 'should not create the user' do
        expect(User.count).to eq 0
      end
      it 'should render new template' do
        expect(response).to render_template :new
      end

      it_behaves_like 'flash[:danger] message'
    end
  end

  describe 'GET #profile' do
    context 'anonymous user' do
      before { clear_current_user }
      it_behaves_like 'require_sign_in' do
        sydney = Fabricate(:user)
        let(:action) { get :profile, params: { id: sydney.id } }
      end
    end

    context 'user logged in' do
      let(:sydney) { Fabricate(:user) }
      before do
        set_current_user
        3.times { sydney.queue_items << Fabricate(:queue_item) }
        get :profile, params: { id: sydney.id }
      end

      it 'should set @user' do
        expect(assigns(:user)).to eq sydney
      end
    end
  end
end
