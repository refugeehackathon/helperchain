class RemoveLocationFromHelpers < ActiveRecord::Migration
  def change
    remove_column :helpers, :location, :string
    remove_column :helpers, :lat, :float
    remove_column :helpers, :long, :float
    add_column :helpers, :project_id, :integer, null: false, default: 1
    remove_index :helpers, :email
    add_index :helpers, [:email, :project_id], unique: true
  end
end
