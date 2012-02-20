class CreateOrphanages < ActiveRecord::Migration
  def change
    create_table :orphanages do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :nature
      t.string :manager_name
      t.string :contact_number
      t.string :account_details
      t.string :email
      t.string :secret_password
      t.boolean :admin_verified, :default => false

      t.timestamps
    end
  end
end
