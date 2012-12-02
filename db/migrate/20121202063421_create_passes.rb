class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.string :code
      t.integer :email_id
      t.string :pk_url
      t.integer :user_id
      t.boolean :sent
      t.string :info

      t.timestamps
    end
  end
end
