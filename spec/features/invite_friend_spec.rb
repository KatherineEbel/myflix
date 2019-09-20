require 'rails_helper'

feature 'Invitations' do
  let(:user) { Fabricate(:user) }
  background do
    sign_in user
  end
  scenario 'user sends invitation' do
    friend = Fabricate.attributes_for(:user)
    visit people_path
    click_link 'Invite a Friend'
    fill_in "Friend's Name", with: friend[:full_name]
    fill_in "Friend's Email Address", with: friend[:email]
    fill_in "Invitation Message", with: 'You will love this video service!'
    click_button 'Send Invitation'
    expect(page).to have_content 'Your invitation has been sent.'
  end
end
