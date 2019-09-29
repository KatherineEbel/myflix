require 'rails_helper'

feature 'Admin' do
  let!(:user) { Fabricate(:user, admin: true) }
  let!(:category) { Fabricate(:category) }
  let(:category_name) { category.name }
  background do
    sign_in(user)
  end
  scenario 'adding a video' do
    video_attrs = Fabricate.attributes_for(:video)
    add_video(video_attrs)
    click_link 'Sign Out'
    sign_in
    click_link(video_attrs[:title])
    click_link 'Watch Now'
    expect(page).to have_current_path(video_attrs[:video_url])
  end
end

def add_video(video_attrs)
  within('.dropdown') do
    find('#user_links').click
    click_link 'Add a Video'
  end
  expect(page).to have_current_path(new_admin_video_path)
  fill_in 'Title', with: video_attrs[:title]
  select category_name, from: 'Category'
  fill_in 'Description', with: video_attrs[:description]

  attach_file 'Large Cover', Rails.root + 'spec/fixtures/monk_large.jpg'
  attach_file 'Small Cover', Rails.root + 'spec/fixtures/monk.jpg'
  fill_in 'Video URL', with: video_attrs[:video_url]
  click_button 'Add Video'
  expect(page).to have_content 'Video added'
end
