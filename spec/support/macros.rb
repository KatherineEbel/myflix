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
end
