require 'rails_helper'

feature 'Invitations' do
  let(:user) { Fabricate(:user) }
  let(:friend) { Fabricate.attributes_for(:user) }
  background do
    Sidekiq::Testing.inline!
    clear_emails
    sign_in user
  end

  scenario 'user invites a friend to MyFlix' do
    send_invitation(friend)
    accept_invitation(friend)
    fill_in 'Email', with: friend[:email]
    fill_in 'Password', with: friend[:password]
    click_button 'Sign In'
    visit people_path
    click_link friend[:full_name]
    expect(page).to have_content user.full_name
  end
end
