require 'spec_helper'

describe LoginController do
  describe "validations" do
    it "should render the login page if the passed secret password and email failed validations" do
      request.env['HTTP_REFERER'] = "http://test.host"
      post :login, :secret_password => "", :email => "invalid_email@address"
      session[:secret_password].should be_nil
      session[:email].should be_nil
      response.should_not redirect_to(:back)
      response.should render_template(:index)
      flash[:alert].should == "Password or Email is in invalid format."
    end
  end

  it "should save the http referrer from request into session to be used as a after sign in url" do
    request.env['HTTP_REFERER'] = "http://test.host"
    get :index
    session[:after_sign_in_url].should == "http://test.host"
  end

  context "after sign in url is not in session" do
    it "should save the secret password and email in session during login and redirect to back url" do
      request.env['HTTP_REFERER'] = "http://test.host"
      post :login, :secret_password => "some password", :email => "email@address.com"
      session[:secret_password].should == "some password"
      session[:email].should == "email@address.com"
      response.should redirect_to(:back)
    end
  end

  context "after sign in url is in session" do
    it "should save the secret password in session during login and redirect to after sign in url" do
      request.env['HTTP_REFERER'] = "http://test.host"
      session[:after_sign_in_url] = "http://test.host/orphanages"
      post :login, :secret_password => "some password", :email => "email@address.com"
      session[:secret_password].should == "some password"
      session[:email].should == "email@address.com"
      response.should redirect_to(session[:after_sign_in_url])
    end
  end

  it "should remove the secret password and email in session during logout" do
    request.env['HTTP_REFERER'] = "http://test.host"
    session[:secret_password] = "some password"
    session[:email] = "some@email.com"
    post :logout
    session[:secret_password].should be_nil
    session[:email].should be_nil
    response.should redirect_to(orphanages_path)
  end
end
