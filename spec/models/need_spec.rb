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
    {:description => "very good need", :nature => "food related", :severity => "critical"}
  end

  describe "validations" do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:nature) }
    it { should validate_presence_of(:severity) }
    it { should validate_presence_of(:status) }

    it "should validate presence of orphanage using a database level constarint" do
      need = Need.new(need_valid_attributes)
      expect { need.save }.should raise_error
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
end
