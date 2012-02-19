module ApplicationHelper
  def logged_in
    session[:secret_password] != nil
  end
end
