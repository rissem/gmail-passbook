class AddFieldsToPass < ActiveRecord::Migration
  def change
    add_column :passes, :title, :string
    add_column :passes, :event_date, :string
    add_column :passes, :location, :string
  end
end
