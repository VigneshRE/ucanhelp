# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
def orphanage_valid_attributes
  {:name => "orphanage", :nature => "old age", :address => "address 1", :city => "bangalore", :manager_name => "mgr", :contact_number => "0807766554", :account_details => "sbi acc", :email => "email@address.com"}
end

def need_valid_attributes
  {:description => "ten chars " * 25, :nature => "food related", :severity => "critical", :deadline => Date.today}
end

puts "Deleting all needs.."
Need.delete_all
puts "Deleting all orphanages.."
Orphanage.delete_all

puts "Loading first 20 bangalore orphanages.."
(1..20).each do |i|
  orphanage = Orphanage.new(orphanage_valid_attributes.merge(:name => "orphanage_#{i}"))
  orphanage.save
end

puts "Loading second 20 chennai orphanages.."
(21..40).each do |i|
  orphanage = Orphanage.new(orphanage_valid_attributes.merge(:name => "orphanage_#{i}", :city => "chennai"))
  orphanage.save
end

puts "Updating secret passwords of orphanages to password.."
Orphanage.all.each do |orphanage|
  orphanage.update_attributes({:secret_password => "password"}, :as => :admin)
end

puts "Creating 10 needs each for first two orphanages.."
orphanages = Orphanage.all(:limit => 2)
orphanages.each do |orphanage|
  (1..10).each do |i|
    need = Need.new(need_valid_attributes)
    need.deadline = Date.today + i
    need.orphanage_id = orphanage.id
    need.save
  end
end
