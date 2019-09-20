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
    fill_in 'Password', with: 'new_password'
    click_button 'Reset Password'
    expect(page).to have_current_path sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign In'
    expect(page).to have_content "Welcome back #{user.full_name}"
  end

  scenario 'email has the content' do
    expect(current_email).to have_content "Hi #{user.full_name}"
  end
end
