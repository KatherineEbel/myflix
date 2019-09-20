require 'rails_helper'

feature 'Forgot Password' do
  let(:user) { Fabricate(:user) }
  background do
    clear_emails
    visit root_path
    click_link 'Sign In'
    click_link 'Forgot Password?'
    fill_in 'Email address', with: user.email
    click_button 'Send Email'
    open_email(user.email)
  end
  scenario 'following email button click' do
    current_email.click_link 'Reset your password'
    expect(page).to have_content('Reset Your Password')
  end

  scenario 'email has the content' do
    expect(current_email).to have_content "Hi #{user.full_name}"
  end
end
