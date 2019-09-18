require 'rails_helper'

feature 'Following people' do
  scenario 'user follows another user' do
    user = Fabricate(:user)
    bob = Fabricate(:user)
    sign_in user
    visit profile_user_path bob
    click_button 'Follow'
    expect(page).to have_content("You are following #{bob.full_name}")
  end

  scenario 'user sees how many people are following them' do
    user = Fabricate(:user)
    bob = Fabricate(:user)
    sign_in user
    visit profile_user_path bob
    click_button 'Follow'
    click_link 'People'
    expect(page).to have_current_path(people_path)
    expect(page).to have_content bob.full_name
    expect(page).to have_content bob.queue_items.count
    expect(page).to have_content bob.followers.count
  end
end
