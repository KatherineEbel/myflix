require 'rails_helper'

feature 'Forgot Password' do
  scenario 'user submits Forgot password' do
    user = Fabricate(:user)
    visit root_path
    click_link 'Sign In'
    click_link 'Forgot Password?'
    fill_in 'Email address', with: user.email
    click_button 'Send Email'
    expect(page).to have_content('Email sent')
  end
end
