require 'spec_helper'

describe OrphanagesController do
  before :each do
    #Transaction not working for tests
    Orphanage.delete_all
    Need.delete_all
  end

  def valid_attributes
    {:name => "orphanage-1", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com", :secret_password => "something"}
  end

  def set_session_password_for(orphanage)
    session[:secret_password] = orphanage.secret_password
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
    it "should validate secret password with session password before editing an orphanage" do
      orphanage = Orphanage.create! valid_attributes
      put :update, :id => orphanage.id.to_s, :orphanage => valid_attributes.merge(:nature => "new age")
      response.should redirect_to(orphanage_path(orphanage))
      flash[:notice].should == "Please login to do this action"
    end

    it "should not let you update an orphanage if the user is not logged in for that password" do
      orphanage_1 = Orphanage.create! valid_attributes
      orphanage_2 = Orphanage.create! valid_attributes.merge(:secret_password => "some other password")
      set_session_password_for(orphanage_2)
      
      put :update, :id => orphanage_1.id.to_s, :orphanage => valid_attributes.merge(:nature => "new age")
      response.should redirect_to(orphanage_path(orphanage_1))
      flash[:notice].should == "You dont have credentials in this orphanage"
    end
  end
end
