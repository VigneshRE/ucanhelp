class LoginController < ApplicationController
  def index
    session[:after_sign_in_url] = request.env['HTTP_REFERER']
  end

  def login
    if input_is_invalid
      flash.now[:alert] = "Password or Email is in invalid format."
      render :action => :index
      return
    end

    session[:secret_password] = params[:secret_password]
    session[:email] = params[:email]
    session[:after_sign_in_url] ? redirect_to(session[:after_sign_in_url]) : redirect_to(:back)
  end

  def logout
    session[:secret_password] = session[:email] = nil
    redirect_to orphanages_path
  end

  private
  def input_is_invalid
    params[:secret_password].nil? || params[:secret_password] == "" || !valid_email(params[:email])
  end

  def valid_email(email)
    return false if !email
    return email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end