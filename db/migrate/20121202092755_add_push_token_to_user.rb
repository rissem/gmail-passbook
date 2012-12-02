class AddPushTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :push_token, :string
  end
end
