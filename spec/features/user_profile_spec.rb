require 'rails_helper'

feature 'User profile' do
  scenario 'user visits another users profile' do
    sydney = Fabricate(:user)
    sydney.queue_items << Fabricate(:queue_item)
    3.times { sydney.reviews << Fabricate(:review) }
    sydney.reviews << Fabricate(:review)
    sign_in Fabricate :user
    visit profile_user_path sydney
    expect(page).to have_content sydney.full_name
    expect(page).to have_content sydney.queue_items.first.video_title
    expect(page).to have_content sydney.queue_items.first.category_name
    sydney.reviews.each do |review|
      expect(page).to have_content review.text
    end
  end

  scenario 'user clicks user name in review to go to their profile' do
    user = Fabricate(:user)
    sign_in user
    video = Fabricate(:video)
    video.reviews << Fabricate(:review)
    review_user = video.reviews.first.reviewer
    visit video_path video
    click_link review_user.full_name
    within('h2') { expect(page).to have_content review_user.full_name }
  end
end
