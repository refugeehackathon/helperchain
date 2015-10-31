class AddAddressToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :town, :string, null: false
    add_column :requests, :street, :string, null: false
    add_column :requests, :address_information, :text
  end
end
