require 'spec_helper'

describe Need do
  before :all do
    #Transaction not working for these tests - seriously no idea
    Orphanage.delete_all
    Need.delete_all
  end

  def orphanage_valid_attributes
    {:name => "orphanage-1", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
  end

  def need_valid_attributes
    {:description => "a" * 250, :nature => "food related", :severity => "critical", :deadline => Date.today}
  end

  describe "validations" do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:nature) }
    it { should validate_presence_of(:severity) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:deadline) }

    it "should have a minimum length of 50 chars" do
      need = Need.new(need_valid_attributes.merge(:description => "a" * 49))
      need.should be_invalid
      need.errors[:description].should include("must be at least 50 characters.")
    end

    it "should have a maximum length of 250 chars" do
      need = Need.new(need_valid_attributes.merge(:description => "a" * 251))
      need.should be_invalid
      need.errors[:description].should include("can have a maximum of only 250 characters.")
    end

    it "should validate presence of orphanage using a database level constarint" do
      need = Need.new(need_valid_attributes)
      expect { need.save }.should raise_error
    end

    it "should validate that deadline date is not in past" do
      need = Need.new(need_valid_attributes.merge(:deadline => Date.yesterday))
      need.should_not be_valid
      need.errors[:deadline].should include "cannot be in past."
    end
  end

  describe "associated orphanage" do
    it "should belong to one orphanage" do
      orphanage = Orphanage.create!(orphanage_valid_attributes)
      need = Need.new(need_valid_attributes)
      need.orphanage_id = orphanage.id
      need.save.should be_true

      need.orphanage.should == orphanage
    end
  end

  describe "scopes" do
    it "should give needs belong to the severity type" do
      orphanage = Orphanage.create!(orphanage_valid_attributes)
      need_1 = Need.create!(need_valid_attributes.merge(:orphanage_id => orphanage.id, :severity => "critical"))
      need_2 = Need.create!(need_valid_attributes.merge(:orphanage_id => orphanage.id, :severity => "critical"))
      need_3 = Need.create!(need_valid_attributes.merge(:orphanage_id => orphanage.id, :severity => "low"))

      Need.count.should == 3
      Need.severity_type("low").count.should == 1
    end
  end
end
