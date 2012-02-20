class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.references :need

      t.timestamps
    end
    add_index :comments, :need_id
  end
end
