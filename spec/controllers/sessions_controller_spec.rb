require 'rails_helper'

describe SessionsController, type: :controller do
  describe '#new' do
    context 'logged in user' do
      before { set_current_user }
      it 'should redirect to home_path' do
        get :new
      end
    end
    context 'new user' do
      it 'should render new template' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe '#create' do
    context 'valid form' do
      before do
        set_current_user
        post :create, params: { email: current_user.email, password: 'password' }
      end
      it 'should redirect to home_path' do
        expect(response).to redirect_to home_path
      end

      it 'should set current_user_id in session' do
        expect(session[:current_user_id]).to eq current_user.id
      end

      it_behaves_like 'flash[:info] message'
    end
    context 'invalid form' do
      before do
        user = Fabricate(:user)
        post :create, params: { email: user.email, password: '' }
      end

      it 'should not set current_user_id in session' do
        expect(session[:current_user_id]).to be_nil
      end

      it_behaves_like 'flash[:danger] message'

      it 'should render new template' do
        expect(response).to render_template :new
      end
    end
  end
end
