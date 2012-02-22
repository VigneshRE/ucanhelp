require 'spec_helper'

describe OrphanagesController do
  before :each do
    #Transaction not working for tests
    Orphanage.delete_all
    Need.delete_all
  end

  def valid_attributes
    {:name => "orphanage-1", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
  end

  def set_session_password_for(orphanage)
    session[:secret_password] = orphanage.secret_password
    session[:email] = orphanage.email
  end

  describe "GET index" do
    it "assigns all orphanages as @orphanages" do
      orphanage = Orphanage.create! valid_attributes
      get :index
      assigns(:orphanages).should eq([orphanage])
    end
  end

  describe "GET show" do
    it "assigns the requested orphanage as @orphanage" do
      orphanage = Orphanage.create! valid_attributes
      get :show, :id => orphanage.id.to_s
      assigns(:orphanage).should eq(orphanage)
    end
  end

  describe "GET new" do
    it "assigns a new orphanage as @orphanage" do
      get :new
      assigns(:orphanage).should be_a_new(Orphanage)
    end
  end

  describe "GET edit" do
    it "assigns the requested orphanage as @orphanage" do
      orphanage = Orphanage.create! valid_attributes
      set_session_password_for(orphanage)
      get :edit, :id => orphanage.id.to_s
      assigns(:orphanage).should eq(orphanage)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Orphanage" do
        expect {
          post :create, :orphanage => valid_attributes
        }.to change(Orphanage, :count).by(1)
      end

      it "assigns a newly created orphanage as @orphanage" do
        post :create, :orphanage => valid_attributes
        assigns(:orphanage).should be_a(Orphanage)
        assigns(:orphanage).should be_persisted
      end

      it "redirects to the created orphanage" do
        post :create, :orphanage => valid_attributes
        response.should redirect_to(Orphanage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved orphanage as @orphanage" do
        # Trigger the behavior that occurs when invalid params are submitted
        Orphanage.any_instance.stub(:save).and_return(false)
        post :create, :orphanage => {}
        assigns(:orphanage).should be_a_new(Orphanage)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested orphanage" do
        orphanage = Orphanage.create! valid_attributes
        set_session_password_for(orphanage)
        # Assuming there are no other orphanages in the database, this
        # specifies that the Orphanage created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Orphanage.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => orphanage.id, :orphanage => {'these' => 'params'}
      end

      it "assigns the requested orphanage as @orphanage" do
        orphanage = Orphanage.create! valid_attributes
        set_session_password_for(orphanage)
        put :update, :id => orphanage.id, :orphanage => valid_attributes.merge("secret_password" => orphanage.secret_password)
        assigns(:orphanage).should eq(orphanage)
      end

      it "redirects to the orphanage" do
        orphanage = Orphanage.create! valid_attributes
        put :update, :id => orphanage.id, :orphanage => valid_attributes.merge("secret_password" => orphanage.secret_password)
        response.should redirect_to(orphanage)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested orphanage" do
      orphanage = Orphanage.create! valid_attributes
      set_session_password_for(orphanage)
      expect {
        delete :destroy, :id => orphanage.id.to_s
      }.to change(Orphanage, :count).by(-1)
    end

    it "redirects to the orphanages list" do
      orphanage = Orphanage.create! valid_attributes
      set_session_password_for(orphanage)
      delete :destroy, :id => orphanage.id.to_s
      response.should redirect_to(orphanages_url)
    end
  end

  describe "secret password validation" do
    it "should validate secret password with session password and email before editing an orphanage" do
      orphanage = Orphanage.create! valid_attributes
      put :update, :id => orphanage.id.to_s, :orphanage => valid_attributes.merge(:nature => "new age")
      response.should redirect_to(orphanage_path(orphanage))
      flash[:notice].should == "Please login to do this action"
    end

    it "should not let you update an orphanage if the user is not logged in for that password" do
      orphanage_1 = Orphanage.create! valid_attributes
      orphanage_2 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_2)

      put :update, :id => orphanage_1.id.to_s, :orphanage => valid_attributes.merge(:nature => "new age")
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == "You dont have credentials in this orphanage"
    end

    it "should not let you update an orphanage with same secret passwords but different email" do
      orphanage_1 = Orphanage.create! valid_attributes.merge(:email => "email@one.com")
      orphanage_1.secret_password = "some other password"
      orphanage_1.save
      orphanage_2 = Orphanage.create! valid_attributes.merge(:email => "email@two.com")
      orphanage_2.secret_password = "some other password"
      orphanage_2.save
      set_session_password_for(orphanage_2)

      put :update, :id => orphanage_1.id.to_s, :orphanage => valid_attributes.merge(:nature => "new age")
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == "You dont have credentials in this orphanage"
    end

    it "should not update the session secret password using mass assignment if orphanage gets updated" do
      orphanage_1 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_1)

      put :update, :id => orphanage_1.id.to_s, :orphanage => valid_attributes.merge(:nature => "new_nature", :secret_password => "new_password")
      response.should redirect_to(orphanage_path(orphanage_1))
      session[:secret_password].should_not == "new_password"
      orphanage_1.nature.should_not == "new_nature"
    end
  end

  describe "scopes" do
    it "should give only admin verified orphanages" do
      orphanage_1 = Orphanage.create!(valid_attributes.merge(:admin_verified => true), :as => :admin)
      orphanage_2 = Orphanage.create!(valid_attributes.merge(:admin_verified => true), :as => :admin)
      orphanage_3 = Orphanage.create!(valid_attributes.merge(:admin_verified => false), :as => :admin)
      get :index, :admin_verified => true
      assigns(:orphanages).count.should == 2
    end
  end
  
  describe "change password" do
    it "should let the user change the secret password" do
      orphanage_1 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_1)

      post :change_secret_password, :id => orphanage_1.id.to_s, :new_password => "new_password", :confirmed_new_password => "new_password"
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == 'Secret Password was successfully updated.'
      session[:secret_password].should == "new_password"
    end

    it "should send an email to the user after change password is done" do
      orphanage_1 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_1)
      mail_message = mock
      mail_message.should_receive(:deliver)
      PasswordMailer.should_receive(:change_secret_password).with(orphanage_1).once.and_return(mail_message)

      post :change_secret_password, :id => orphanage_1.id.to_s, :new_password => "new_password", :confirmed_new_password => "new_password"
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == 'Secret Password was successfully updated.'
      session[:secret_password].should == "new_password"
    end

    it "should not change the secret password if the new password and its confirmation did not match" do
      orphanage_1 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_1)

      post :change_secret_password, :id => orphanage_1.id.to_s, :new_password => "new_password", :confirmed_new_password => "new_password_1"
      flash[:notice].should == 'New password did not match with new confirmed password.'
      session[:secret_password].should_not == "new_password"
    end

    it "should not change the secret password if the new password and its confirmation are empty" do
      orphanage_1 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_1)

      post :change_secret_password, :id => orphanage_1.id.to_s, :new_password => "", :confirmed_new_password => ""
      flash[:notice].should == 'New password did not match with new confirmed password.'
      session[:secret_password].should_not == "new_password"
    end

    it "should not change the secret password in session if the update fails" do
      orphanage_1 = Orphanage.create! valid_attributes
      set_session_password_for(orphanage_1)
      Orphanage.any_instance.stub(:update_attributes).and_return(false)

      post :change_secret_password, :id => orphanage_1.id.to_s, :new_password => "new_password", :confirmed_new_password => "new_password"
      session[:secret_password].should_not == "new_password"
    end
  end
  
  describe "forgot secret password" do
    it "should send secret password details of all the orphanages in an email" do
      orphanage_1 = Orphanage.create! valid_attributes
      orphanage_2 = Orphanage.create! valid_attributes
      mail_message = mock
      mail_message.should_receive(:deliver)
      PasswordMailer.should_receive(:forgot_secret_password).once.and_return(mail_message)

      post :forgot_secret_password, :id => orphanage_1.id.to_s, :email => "email@address.com"
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == 'Secret password has been mailed to your email address successfully.'
    end

    it "should not send secret password details if there are no orphanages for an email" do
      orphanage_1 = Orphanage.create! valid_attributes
      orphanage_2 = Orphanage.create! valid_attributes
      PasswordMailer.should_not_receive(:forgot_secret_password)

      post :forgot_secret_password, :id => orphanage_1.id.to_s, :email => "no-orphaage-email@address.com"
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == 'There are no orphanages associated with the given email.'
    end

    it "should redirect to forgot secret password if email is not given" do
      orphanage_1 = Orphanage.create! valid_attributes
      orphanage_2 = Orphanage.create! valid_attributes

      post :forgot_secret_password, :id => orphanage_1.id.to_s
      response.should redirect_to(forgot_secret_password_orphanage_path(orphanage_1))
      flash[:notice].should == 'Please provide a valid email address.'
    end

    it "should redirect to forgot secret password if email is not in the valid format" do
      orphanage_1 = Orphanage.create! valid_attributes
      orphanage_2 = Orphanage.create! valid_attributes

      post :forgot_secret_password, :id => orphanage_1.id.to_s, :email => "invalid_email_format"
      response.should redirect_to(forgot_secret_password_orphanage_path(orphanage_1))
      flash[:notice].should == 'Please provide a valid email address.'
    end
  end
end
