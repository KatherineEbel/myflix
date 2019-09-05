require 'rails_helper'

describe SessionsController, type: :controller do
  let(:user) { Fabricate(:user) }
  describe '#new' do
    context 'logged in user' do
      it 'should redirect to home_path' do
        get :new, session: { current_user_id: user.to_param }
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
        post :create, params: { email: user.email, password: user.password }
      end
      it 'should redirect to home_path' do
        expect(response).to redirect_to home_path
      end

      it 'should set current_user_id in session' do
        expect(session[:current_user_id]).to eq user.id
      end

      it 'should set flash[:info] message' do
        expect(flash[:info]).to be_present
      end
    end
    context 'invalid form' do
      before do
        post :create, params: { email: user.email, password: 'abc123'}
      end

      it 'should not set current_user_id in session' do
        expect(session[:current_user_id]).to be_nil
      end
      it 'should set flash[:danger] message ' do
        expect(flash[:danger]).to be_present
      end

      it 'should render new template' do
        expect(response).to render_template :new
      end
    end
  end
end
