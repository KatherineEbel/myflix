# frozen_string_literal: true

require 'rails_helper'

describe VideosController, type: :controller do
  let(:video) { Fabricate(:video) }
  let(:user) { Fabricate(:user) }
  describe '#show' do
    context 'user is not logged in' do
      it 'redirects to root_path' do
        get :show, params: { id: video.to_param }
        expect(response).to redirect_to root_path
      end
    end
    context 'user is logged in' do
      it 'should set @video' do
        get :show, params: { id: video.to_param },
                   session: { current_user_id: user.to_param }
        expect(assigns(:video)).to eq video
      end
    end
  end

  describe '#search' do
    context 'when user is not logged in' do
      it 'should redirect to root_path' do
        get :search, params: { query: video.title }
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is logged in' do
      it 'should set @videos' do
        get :search, params: { query: video.title },
                     session: { current_user_id: user.to_param }
        expect(assigns(:videos)).to eq [video]
      end
    end
  end
end
