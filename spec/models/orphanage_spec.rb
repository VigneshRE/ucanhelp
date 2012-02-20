require 'spec_helper'

describe Orphanage do
  def orphanage_valid_attributes
    {:name => "orphanage-1", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
  end

  def need_valid_attributes
    {:description => "very good need", :nature => "food related", :severity => "critical"}
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:nature) }
    it { should validate_presence_of(:manager_name) }
    it { should validate_presence_of(:contact_number) }
    it { should validate_presence_of(:account_details) }
    it { should validate_presence_of(:email) }

    it "should validate format of email" do
      orphanage = Orphanage.new(:email => "email")
      orphanage.should_not be_valid
      orphanage.errors.values.should include ["is not formatted properly"]
      orphanage = Orphanage.new(:email => "email@address.com")
      orphanage.errors.values.should_not include(["is not formatted properly"])
    end
  end

  describe "associated needs" do
    it "should have many needs" do
      need = Need.new(need_valid_attributes)
      orphanage = Orphanage.new(orphanage_valid_attributes)
      orphanage.needs = [need]
      orphanage.save

      orphanage.needs.should_not be_empty
      orphanage.needs.first.should == need
    end

    it "should delete the associated needs" do
      need = Need.new(need_valid_attributes)
      orphanage = Orphanage.new(orphanage_valid_attributes)
      orphanage.needs = [need]
      orphanage.save

      Orphanage.count.should == 1
      Need.count.should == 1

      orphanage.destroy
      Orphanage.count.should == 0
      Need.count.should == 0
    end
  end

  describe "secret password" do
    it "should populate secret password before creating the orphanage" do
      orphanage = Orphanage.new(orphanage_valid_attributes)
      orphanage.should be_valid
      orphanage.secret_password.should_not be_empty
    end
  end

  describe "admin verified orphanage" do
    it "should not let admin verified to be set by mass assignment" do
      orphanage = Orphanage.create! orphanage_valid_attributes.merge(:admin_verified => true)
      orphanage.admin_verified.should be_false
    end

    it "should let admin verified to be set by mass assignment only as admin user" do
      orphanage = Orphanage.create!(orphanage_valid_attributes.merge(:admin_verified => true), :as => :admin)
      orphanage.admin_verified.should be_true
    end
  end
end
