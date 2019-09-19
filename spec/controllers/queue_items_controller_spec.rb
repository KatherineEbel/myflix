require 'rails_helper'

describe QueueItemsController, type: :controller do
  before { set_current_user }
  describe 'GET #index' do
    context 'anonymous user' do
      it_behaves_like 'require_sign_in' do
        let(:action) { get :index }
      end
    end

    context 'logged in user' do
      it 'should set @queue_items' do
        get :index
        expect(assigns(:queue_items)).to_not be nil
      end

      it 'should render the index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST #create' do
    context 'anonymous user' do
      before { clear_current_user }
      it 'should redirect to root_path' do
        video = Fabricate(:video)
        post :create, params: { video_id: video.to_param }
        expect(response).to redirect_to root_path
      end
    end

    context 'logged in user' do
      let(:video) { Fabricate(:video) }

      before do
        post :create, params: { video_id: video.to_param }
      end

      it 'should set @queue_item' do
        expect(assigns(:queue_item)).to be_instance_of QueueItem
      end

      it 'should create the queue_item for the current_user' do
        expect(current_user.queue_items.count).to eq 1
      end

      it 'should redirect to my_queue' do
        expect(response).to redirect_to my_queue_path
      end

      it 'should display flash[:info]' do
        expect(flash[:info]).to be_present
      end

      context 'video already in queue' do
        before do
          post :create, params: { video_id: video.to_param }
        end

        it "should redirect_to video_path for " do
          expect(response).to redirect_to video_path video
        end

        it_behaves_like 'flash[:danger] message'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'anonymous user' do
      before { clear_current_user }
      it 'should redirect to root_path' do
        queue_item = Fabricate(:queue_item)
        delete :destroy, params: { id: queue_item.to_param }
        expect(response).to redirect_to root_path
      end
    end

    context 'logged in user' do
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }

      it 'should remove the item from the current_user queue' do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: video1)
        delete :destroy, params: { id: queue_item1.to_param }
        expect(current_user.queue_items).to_not include queue_item1
      end

      it 'should normalize the priorities in the users queue' do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: video1)
        Fabricate(:queue_item, user: current_user, video: video2)
        delete :destroy, params: { id: queue_item1.to_param }
        expect(current_user.queue_items.first.priority).to eq 1
      end

      it 'should redirect user back to my_queue page' do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: video1)
        delete :destroy, params: { id: queue_item1.to_param }
        expect(response).to redirect_to my_queue_path
      end

      it 'should display flash[:info]' do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: video1)
        delete :destroy, params: { id: queue_item1.to_param }
        expect(flash[:info]).to be_present
      end

      context 'delete another users queue item' do
        let(:bob) { Fabricate(:user) }
        let(:bobs_item) { Fabricate(:queue_item, user: bob) }

        before do
          current_user = Fabricate(:user)
          delete :destroy, params: { id: bobs_item.to_param },
                           session: { current_user_id: current_user.id }
        end

        it 'should not delete a queue item in someone elses queue' do
          expect(bob.queue_items).to include(bobs_item)
        end

        it 'should display flash[:danger] message' do
          expect(flash[:danger]).to be_present
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'anonymous user' do
      before { clear_current_user }
      it 'should redirect to root_path' do
        patch :update, params: { queue_item: { "1": { priority: 2 } } }
        expect(response).to redirect_to root_path
      end
    end

    context 'logged in user' do
      before do
        Fabricate.times(3, :queue_item, user: current_user)
        patch :update,
              params: { user: { queue_items_attributes:
                          {
                            "0": { priority: 6, id: current_user.queue_items.first.to_param },
                            "1": { priority: 2, id: current_user.queue_items.second.to_param },
                            "2": { priority: 3, id: current_user.queue_items.third.to_param }
                          } } }
      end

      context 'updating priorities and reviews' do
        it 'should redirect to my_queue path' do
          expect(response).to redirect_to my_queue_path
        end

        it_behaves_like 'flash[:info] message'
      end

      context 'different user' do
        let(:bob) { Fabricate(:user) }
        before do
          Fabricate.times(2, :queue_item, user: bob)
          attributes = { '0': { priority: 3, review: 4, id: bob.queue_items.first.to_param },
                         '1': { priority: 2, review: '', id: bob.queue_items.second.to_param } }
          patch :update,
                params:
                  { user: { queue_items_attributes: attributes } }
        end
        it 'should not update priorities' do
          expect(bob.queue_items.first.priority).to eq 1
          expect(bob.reviews.count).to eq 0
        end

        it_behaves_like 'flash[:danger] message'
      end

      context 'invalid input' do
        it 'should not update the values' do
          current_user.queue_items.destroy_all
          Fabricate(:queue_item, user: current_user)
          Fabricate(:queue_item, user: current_user)
          attributes = { '0': { priority: 3.2, id: current_user.queue_items.first.to_param },
                         '1': { priority: 2, id: current_user.queue_items.second.to_param } }
          patch :update, params: { user: { queue_items_attributes: attributes } }
          expect(current_user.queue_items.first.priority).to eq 1
        end
      end
    end
  end
end
