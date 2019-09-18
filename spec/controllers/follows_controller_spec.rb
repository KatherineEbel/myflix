require 'rails_helper'

describe FollowsController do
  describe 'POST #create' do
    context 'anonymous user' do
      it_behaves_like 'require_sign_in' do
        let(:action) { post :create }
      end
    end
    context 'logged in user' do
      let(:bob) { Fabricate(:user) }
      before do
        set_current_user
        post :create, params: { id: bob.to_param }
      end

      context 'other user is not followed by current_user' do
        it_behaves_like 'flash[:success] message'
        it 'should redirect back to other users profile' do
          expect(response).to redirect_to profile_user_path current_user.followees.first
        end
      end

      context 'other user is followed by current_user' do
        before { post :create, params: { id: bob.to_param } }
        it_behaves_like 'flash[:danger] message'
        it 'should redirect back to other users profile' do
          expect(response).to redirect_to profile_user_path current_user.followees.first
        end
      end
    end
  end

  describe 'GET #show' do
    context 'anonoymous user' do
      it { should use_before_action(:require_user) }
      it_behaves_like 'require_sign_in' do
        let(:action) { get :show }
      end
    end

    context 'logged in user' do
      before { set_current_user }
      it 'should set @followees' do
        bob = Fabricate(:user)
        current_user.follow!(bob)
        get :show
        expect(assigns(:followees)).to match_array [bob]
      end
    end
  end

  describe 'DESTROY #destroy' do
    context 'anonymous user' do
      it_behaves_like 'require_sign_in' do
        let(:action) { delete :destroy, params: { id: 1 } }
      end
    end

    context 'logged in user' do
      before do
        set_current_user
      end
      context 'success' do
        let(:other_user) { Fabricate(:user) }
        before do
          current_user.follow! other_user
          delete :destroy, params: { id: other_user.to_param }
        end
        it_behaves_like 'flash[:success] message'

        it 'should remove other_user from followees' do
          expect(current_user.followees).to_not include other_user
        end
      end

      context 'other_user not followed' do
        let(:other_user) { Fabricate(:user) }
        before do
          delete :destroy, params: { id: other_user.to_param }
        end
        it_behaves_like 'flash[:warning] message'
      end
    end
  end
end
