require 'rails_helper'

describe ReviewsController, type: :controller do
  describe '#create' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:review_data) { Fabricate.attributes_for(:review) }

    context 'anonymous user' do
      it 'should redirect user to root_path' do
        review_data[:user] = nil
        post :create, params: { video_id: video.id, review: review_data }
        expect(response).to redirect_to root_path
      end
    end

    it 'should set @review' do
      post :create, params: { video_id: video.id, review: review_data },
                    session: { current_user_id: user.id }
      expect(assigns(:review)).to be_instance_of Review
    end

    context 'valid form' do
      before do
        review_data[:user_id] = user.id
        review_data[:video_id] = video.id
        post :create, params: { video_id: video.id, review: review_data },
                      session: { current_user_id: user.id }
      end
      it 'should create the review' do
        expect(Review.count).to be 1
      end

      it 'should redirect to video_path' do
        expect(response).to redirect_to video_path video
      end

      it 'should display flash[:info]' do
        expect(flash[:info]).to be_present
      end
    end

    context 'invalid form' do
      before do
        review_data[:rating] = nil
        post :create, params: { video_id: video.id, review: review_data },
                      session: { current_user_id: user.id }
      end
      it 'should not save the review' do
        expect(Review.count).to be 0
      end

      it 'should render video_path' do
        expect(response).to render_template 'videos/show'
      end

      it 'should display flash[:danger]' do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
