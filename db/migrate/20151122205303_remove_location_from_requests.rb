class RemoveLocationFromRequests < ActiveRecord::Migration
  def change
    remove_column :requests, :location, :string
    remove_column :requests, :lat, :float
    remove_column :requests, :long, :float
    remove_column :requests, :range, :integer
    remove_column :requests, :address_information, :string
    rename_column :requests, :member_in_charge_id, :manager_in_charge_id
  end
end
