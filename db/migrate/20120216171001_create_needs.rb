class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.references :orphanage, :null => false
      t.string :description
      t.string :nature
      t.string :severity
      t.string :status, :default => Need::OPEN
      t.date :deadline

      t.timestamps
    end
  end
end
