require 'rails_helper'

describe Admin::VideosController do
  describe 'GET #new' do
    context 'regular user' do
      before do
        set_current_user
        get :new
      end
      it_behaves_like 'ensure_admin' do
        let(:action) { get :new }
      end
    end

    context 'admin user' do
      before do
        set_current_user(true)
        get :new
      end

      it { should render_template :new }

      it 'should set @video' do
        expect(assigns(:video)).to be_instance_of Video
      end
    end
  end

  describe 'POST #create' do
    context 'regular user' do
      before do
        set_current_user
      end

      it_behaves_like 'ensure_admin' do
        let(:action) { post :create }
      end
    end

    context 'admin user' do
      let(:video_attrs) { Fabricate.attributes_for(:video) }
      let(:params) { { video: video_attrs } }
      before do
        set_current_user(true)
      end

      context 'valid form' do
        before { post :create, params: params }

        it 'should set @video' do
          expect(assigns(:video)).to be_instance_of Video
        end

        it { should permit(
                      :title, :description,
                      :large_cover_url, :small_cover_url)
                      .for(:create, params: params).on(:video) }

        it_should_behave_like 'flash[:success] message'
        it { should redirect_to new_admin_video_path }
      end

      context 'submits invalid form' do
        before do
          params[:video][:description] = nil
          post :create, params: params
        end

        it_should_behave_like 'flash[:danger] message'
        it { should render_template :new }

      end
    end

  end
end
