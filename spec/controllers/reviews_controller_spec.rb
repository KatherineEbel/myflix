require 'rails_helper'

describe ReviewsController, type: :controller do
  before { set_current_user }
  describe 'POST #create' do
    let(:review_data) { Fabricate.attributes_for(:review) }

    context 'anonymous user' do
      it_behaves_like 'require_sign_in' do
        let(:action) do
          post :create, params: { video_id: review_data[:video_id], review: review_data }
        end
      end
    end

    context 'logged in user' do
      context 'valid form' do
        before do
          post :create, params: { video_id: review_data[:video_id], review: review_data }
        end

        it 'should set @review' do
          expect(assigns(:review)).to be_instance_of Review
        end

        it 'should create the review' do
          expect(Review.count).to be 1
        end

        it 'should redirect to video_path' do
          video = Review.first.video
          expect(response).to redirect_to video_path video
        end

        it_behaves_like 'flash[:info] message'
      end

      context 'invalid form' do
        before do
          review_data[:rating] = nil
          post :create, params: { video_id: review_data[:video_id], review: review_data }
        end
        it 'should not save the review' do
          expect(Review.count).to be 0
        end

        it 'should render video_path' do
          expect(response).to render_template 'videos/show'
        end

        it_behaves_like 'flash[:danger] message'
      end
    end

  end
end
