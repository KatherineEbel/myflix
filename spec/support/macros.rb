def set_current_user
  user = Fabricate(:user, password: 'password')
  session[:current_user_id] = user.id
end

def current_user
  User.find(session[:current_user_id])
end

def clear_current_user
  session[:current_user_id] = nil
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign In'
  expect(page).to have_current_path(home_path)
  user
end

def follow_user(user)
  sign_in
  visit profile_user_path user
  click_button 'Follow'
end

def register(user)
  fill_in 'Email', with: user[:email]
  fill_in 'Password', with: user[:password]
  fill_in 'Full name', with: user[:full_name]
  click_button 'Sign Up'
  expect(page).to have_content 'Registration completed'
end

def send_invitation(friend)
  visit people_path
  click_link 'Invite a Friend'
  fill_in "Friend's Name", with: friend[:full_name]
  fill_in "Friend's Email Address", with: friend[:email]
  fill_in "Invitation Message", with: 'You will love this video service!'
  click_button 'Send Invitation'
  expect(page).to have_content 'Your Invitation has been sent.'
end

def accept_invitation(friend)
  open_email(friend[:email])
  current_email.click_link 'Sign Up For MyFlix'
  expect(page).to have_content 'Register'
  register(friend)
end
