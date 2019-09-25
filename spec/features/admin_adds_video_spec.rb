require 'rails_helper'

feature 'Admin' do
  let(:user) { Fabricate(:user, admin: true) }
  let!(:category) { Fabricate(:category) }
  let(:category_name) { category.name }
  background do
    sign_in(user)
  end
  scenario 'adding a video' do
    click_link 'Add a Video'
    expect(page).to have_current_path(new_admin_video_path)
    video_attrs = Fabricate.attributes_for(:video)
    fill_in 'Title', with: video_attrs[:title]
    select category_name, from: 'Category'
    fill_in 'Description', with: video_attrs[:description]
    attach_file 'Large Cover', Rails.root + 'spec/fixtures/monk_large.jpg'
    attach_file 'Small Cover', Rails.root + 'spec/fixtures/monk.jpg'
    click_button 'Add Video'
    expect(page).to have_content 'Video added'
  end
end
