def set_current_user
  user = Fabricate(:user, password: 'password')
  session[:current_user_id] = user.id
end

def current_user
  User.find(session[:current_user_id])
end

def clear_current_user
  User.destroy(session[:current_user_id])
  session[:current_user_id] = nil
end

def new_user
  Fabricate(:user)
end