require 'spec_helper'

describe Orphanage do
  def orphanage_valid_attributes
    {:name => "orphanage-1", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
  end

  def need_valid_attributes
    {:description => "very good need", :nature => "food related", :severity => "critical", :deadline => Date.today}
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

    it "should validate that city name should be in the predefined city list" do
      orphanage = Orphanage.new(orphanage_valid_attributes.merge(:city => "delhi"))
      orphanage.should_not be_valid
      orphanage.errors[:city].should include("name not valid")
      orphanage = Orphanage.new(orphanage_valid_attributes.merge(:city => "chennai"))
      orphanage.should be_valid
    end

    it "should validate that contact number is an integer" do
      orphanage = Orphanage.new(orphanage_valid_attributes.merge(:contact_number => "delhi9.8"))
      orphanage.should_not be_valid
      orphanage.errors[:contact_number].should include("is not a number")
      orphanage = Orphanage.new(orphanage_valid_attributes.merge(:contact_number => "9.88767"))
      orphanage.should_not be_valid
      orphanage.errors[:contact_number].should include("must be an integer")
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

    it "should not update the secret password by mass assignment" do
      orphanage = Orphanage.create(orphanage_valid_attributes)
      orphanage.update_attributes!(:secret_password => "new_password")
      orphanage.secret_password.should_not == "new_password"
    end

    it "should update the secret password as an admin" do
      orphanage = Orphanage.create(orphanage_valid_attributes)
      orphanage.update_attributes!({:secret_password => "new_password"}, :as => :admin)
      orphanage.secret_password.should == "new_password"
    end
  end

  describe "registration password" do
    it "should populate registration password before creating an orphanage" do
      orphanage = Orphanage.new(orphanage_valid_attributes)
      orphanage.should be_valid
      orphanage.registration_password.should_not be_empty
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

  describe "scopes" do
    it "should give only admin verified orphanages" do
      orphanage_1 = Orphanage.create!(orphanage_valid_attributes.merge(:admin_verified => true), :as => :admin)
      orphanage_2 = Orphanage.create!(orphanage_valid_attributes.merge(:admin_verified => true), :as => :admin)
      orphanage_3 = Orphanage.create!(orphanage_valid_attributes.merge(:admin_verified => false), :as => :admin)

      Orphanage.count.should == 3
      Orphanage.admin_verified.count.should == 2
    end

    it "should give only registered orphanages" do
      orphanage_1 = Orphanage.create!(orphanage_valid_attributes.merge(:registered => true))
      orphanage_2 = Orphanage.create!(orphanage_valid_attributes.merge(:registered => true))
      orphanage_3 = Orphanage.create!(orphanage_valid_attributes.merge(:registered => false))

      Orphanage.count.should == 3
      Orphanage.registered.count.should == 2
    end

    it "should give orphanages belongs to the given city" do
      orphanage_1 = Orphanage.create!(orphanage_valid_attributes.merge(:city => "Bangalore"))
      orphanage_2 = Orphanage.create!(orphanage_valid_attributes.merge(:city => "Bangalore"))
      orphanage_3 = Orphanage.create!(orphanage_valid_attributes.merge(:city => "Chennai"))

      Orphanage.count.should == 3
      Orphanage.city_name("Chennai").count.should == 1
    end

    it "should give all orphanages if the given city is All" do
      orphanage_1 = Orphanage.create!(orphanage_valid_attributes.merge(:city => "Bangalore"))
      orphanage_2 = Orphanage.create!(orphanage_valid_attributes.merge(:city => "Bangalore"))
      orphanage_3 = Orphanage.create!(orphanage_valid_attributes.merge(:city => "Chennai"))

      Orphanage.count.should == 3
      Orphanage.city_name("All").count.should == 3
    end
  end
end
