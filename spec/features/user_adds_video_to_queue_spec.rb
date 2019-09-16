require 'rails_helper'

feature 'Add Video to Queue' do
  scenario 'for signed in user' do
    south_park = Fabricate(:video, title: 'South Park')
    sign_in
    click_link(south_park.title)
    expect(page).to have_current_path(video_path(south_park))
    click_link '+ My Queue'
    expect(page).to have_content south_park.title
    click_link(south_park.title)
    expect(page).to have_content south_park.description
    expect(page).to_not have_content '+ My Queue'
  end
end