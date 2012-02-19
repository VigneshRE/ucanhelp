class LoginController < ApplicationController
  def index
    session[:after_sign_in_url] = request.env['HTTP_REFERER']
  end

  def login
    session[:secret_password] = params[:secret_password]
    if session[:after_sign_in_url]
      redirect_to session[:after_sign_in_url]
    else
      redirect_to :back
    end
  end

  def logout
    session[:secret_password] = nil
    redirect_to orphanages_path
  end
end