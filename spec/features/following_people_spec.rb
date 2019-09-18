require 'rails_helper'

feature 'Following people' do
  scenario 'user follows another user' do
    other_user = Fabricate(:user)
    follow_user other_user
    expect(page).to have_content("You are following #{other_user.full_name}")
  end

  scenario 'user sees how many people are following them' do
    bob = Fabricate(:user)
    follow_user bob
    click_link 'People'
    expect(page).to have_current_path(people_path)
    expect(page).to have_content bob.full_name
    expect(page).to have_content bob.queue_items.count
    expect(page).to have_content bob.followers.count
  end

  scenario 'user removes a followee' do
    bob = Fabricate(:user)
    follow_user bob
    visit people_path
    within("tr#followee-#{bob.id}") do
      find_button(type: 'submit').click
    end
    expect(page).to_not have_content bob.full_name
    expect(page).to_not have_content 'Invalid request'
  end
end
