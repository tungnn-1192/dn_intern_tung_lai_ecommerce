def sign_in user
  session[:user_id] = user.id if user.user?
  session[:admin_id] = user.id if user.admin?
end
