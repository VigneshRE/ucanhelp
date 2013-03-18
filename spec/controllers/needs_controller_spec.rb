require 'spec_helper'

describe NeedsController do
  before :all do
    #Transaction not working for these tests - seriously no idea
    Orphanage.delete_all
    Need.delete_all
    @orphanage = Orphanage.create(orphanage_valid_attributes)
  end

  before :each do
    set_session_password_for(@orphanage)
  end

  def orphanage_valid_attributes
    {:name => "orphanage-1", :nature => OrphanageNatureList.all.first, :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
  end

  def valid_attributes
    {:description => "a" * 250, :nature => "Education", :severity => "critical", :orphanage_id => @orphanage.id, :deadline => Date.today}
  end

  def set_session_password_for(orphanage)
    session[:secret_password] = orphanage.secret_password
  end

  describe "GET index" do
    it "assigns all needs as @needs" do
      need = Need.create! valid_attributes
      get :index
      assigns(:needs).should eq([need])
    end

    it "assigns all needs as @needs for the given orphanage" do
      need_1 = Need.create! valid_attributes
      need_2 = Need.new valid_attributes
      need_2.orphanage = Orphanage.create({:name => "orphanage-1", :nature => OrphanageNatureList.all.first, :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email2@address.com"})
      need_2.save
      get :index, :orphanage_id => @orphanage.id
      assigns(:needs).should eq([need_1])
    end
  end

  describe "GET show" do
    it "assigns the requested need as @need" do
      need = Need.create! valid_attributes
      get :show, :id => need.id.to_s, :orphanage_id => @orphanage.id
      assigns(:need).should eq(need)
    end
  end

  describe "GET new" do
    it "assigns a new need as @need" do
      get :new, :orphanage_id => @orphanage.id
      assigns(:need).should be_a_new(Need)
    end
  end

  describe "GET edit" do
    it "assigns the requested need as @need" do
      need = Need.create! valid_attributes
      get :edit, :id => need.id.to_s, :orphanage_id => @orphanage.id
      assigns(:need).should eq(need)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Need" do
        expect {
          post :create, :need => valid_attributes, :orphanage_id => @orphanage.id
        }.to change(Need, :count).by(1)
      end

      it "assigns a newly created need as @need" do
        post :create, :need => valid_attributes, :orphanage_id => @orphanage.id
        assigns(:need).should be_a(Need)
        assigns(:need).should be_persisted
      end

      it "redirects to the created need" do
        post :create, :need => valid_attributes, :orphanage_id => @orphanage.id
        response.should redirect_to(orphanage_need_path(:id => Need.last.id, :orphanage_id => @orphanage.id))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved need as @need" do
        # Trigger the behavior that occurs when invalid params are submitted
        Need.any_instance.stub(:save).and_return(false)
        post :create, :need => {}, :orphanage_id => @orphanage.id
        assigns(:need).should be_a_new(Need)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested need" do
        need = Need.create! valid_attributes
        # Assuming there are no other needs in the database, this
        # specifies that the Need created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Need.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => need.id, :need => {'these' => 'params'}, :orphanage_id => @orphanage.id
      end

      it "redirects to the need" do
        pending "need to fix it"
        need = Need.create! valid_attributes
        put :update, :id => need.id, :need => valid_attributes
        response.should redirect_to(need)
      end
    end

    describe "with invalid params" do
      it "assigns the need as @need" do
        need = Need.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Need.any_instance.stub(:save).and_return(false)
        put :update, :id => need.id.to_s, :need => {}, :orphanage_id => @orphanage.id
        assigns(:need).should eq(need)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested need" do
      need = Need.create! valid_attributes
      expect {
        delete :destroy, :id => need.id.to_s, :orphanage_id => @orphanage.id
      }.to change(Need, :count).by(-1)
    end
  end

  describe "secret password validation" do
    it "should not allow a need to be created if the secret password validation fails" do
      orphanage_2 = Orphanage.create(orphanage_valid_attributes.merge(:secret_password => "some other password"))
      set_session_password_for(orphanage_2)
      request.env['HTTP_REFERER'] = "http://test.host" + orphanage_needs_path(@orphanage)

      expect {
        post :create, :need => valid_attributes, :orphanage_id => @orphanage.id, :secret_password => "some wrong value"
      }.not_to change(Need, :count).by(1)

      response.should redirect_to(:back)
      flash[:alert].should == "You dont have credentials in this orphanage"
    end
  end

  describe "close" do
    it "should change the status of a need to close" do
      need = Need.create! valid_attributes
      need.status.should == Need::OPEN
      get :close, :id => need.id.to_s, :orphanage_id => @orphanage.id
      response.should redirect_to(orphanage_need_path(:id => need.id, :orphanage_id => @orphanage.id))
      flash[:notice].should == "Need status successfully changed."
      need.reload.status.should == Need::CLOSED
    end

    it "should send a notice if need status change fails" do
      need = Need.create! valid_attributes
      need.status.should == Need::OPEN
      Need.any_instance.stub(:save).and_return(false)
      get :close, :id => need.id.to_s, :orphanage_id => @orphanage.id
      response.should redirect_to(orphanage_need_path(:id => need.id, :orphanage_id => @orphanage.id))
      flash[:alert].should == "Could not change Need status."
      need.reload.status.should == Need::OPEN
    end
  end
end
