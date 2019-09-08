require 'rails_helper'

describe QueueItemsController, type: :controller do
  describe '#index' do
    context 'anonymous user' do
      it 'should redirect to root_path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'logged in user' do
      let(:user) { Fabricate(:user) }
      it 'should set @queue_items' do
        get :index, session: {current_user_id: user.to_param }
        expect(assigns(:queue_items)).to_not be nil
      end

      it 'should render the index template' do
        get :index, session: {current_user_id: user.to_param }
        expect(response).to render_template :index
      end
    end
  end
end
