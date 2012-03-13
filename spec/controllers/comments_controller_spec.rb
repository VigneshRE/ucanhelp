require 'spec_helper'

describe CommentsController do
  before :all do
    #Transaction not working for these tests - seriously no idea
    Orphanage.delete_all
    Need.delete_all
    Comment.delete_all
    @orphanage = Orphanage.create(orphanage_valid_attributes)
    @need = Need.create(need_valid_attributes)
  end

  def orphanage_valid_attributes
    {:name => "orphanage-1", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
  end

  def need_valid_attributes
    {:description => "a" * 250, :nature => "Education", :severity => "critical", :orphanage_id => @orphanage.id, :deadline => Date.today}
  end

  def valid_attributes
    {:commenter => "some person", :body => "food related comment", :orphanage_id => @orphanage.id, :need_id => @need.id}
  end
  
  describe "create" do
    it "should redirect to the corresponding need path" do
      post :create, valid_attributes
      response.should redirect_to(orphanage_need_path(:orphanage_id => @orphanage.id, :id => @need.id))
    end
  end
end
