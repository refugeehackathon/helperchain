class ReplaceStreetTownWithLocationInRequest < ActiveRecord::Migration
  def change
    rename_column :requests, :town, :location
    remove_column :requests, :street
  end
end
