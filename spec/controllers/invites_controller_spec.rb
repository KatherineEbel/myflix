require 'rails_helper'

describe InvitesController do
  describe 'GET #new' do
    context 'anonymous user' do
      it_behaves_like 'require_sign_in' do
        let(:action) { get :new }
      end
    end

    context 'signed in user' do
      before { set_current_user }
      it 'should set @invite' do
        get :new
        expect(assigns(:invite)).to be_an_instance_of Invite
      end
    end
  end
  describe 'POST #create' do
    context 'anonymous user' do
      it_behaves_like 'require_sign_in' do
        let(:action) { post :create }
      end
    end

    context 'signed in user' do
      before do
        set_current_user
      end

      context 'valid form' do
        let(:friend) { Fabricate.attributes_for(:user) }
        before do
          post :create, params: { invite: {
            friend_name: friend[:full_name],
            friend_email: friend[:email],
            inviter_id: current_user.id,
            message: 'Check out this service I found!'
          } }
        end

        it 'should set @invite' do
          invite = assigns(:invite)
          expect(invite).to be_an_instance_of Invite
        end

        context 'invite email' do
          it 'should send the email' do
            expect(InviteEmailWorker.jobs.size).to eq 1
          end

          it 'should be sent to the friends email' do
            invite = Invite.new.from_json(InviteEmailWorker.jobs.last['args'].first)
            expect(invite.friend_email).to eq friend[:email]
          end
        end
        it { should redirect_to people_path }
        it_behaves_like 'flash[:success] message'
      end

      context 'invalid form' do
        let(:friend) { Fabricate.attributes_for(:user) }
        before do
          post :create, params: { invite: {
            message: 'Check out this service I found!'
          } }
        end

        it 'should set @invite' do
          expect(assigns(:invite)).to be_an_instance_of Invite
        end

        it { should render_template :new }

      end
    end
  end
end
