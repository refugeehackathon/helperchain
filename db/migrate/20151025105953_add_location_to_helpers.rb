class AddLocationToHelpers < ActiveRecord::Migration
  def change
    add_column :helpers, :location, :string, null: false
  end
end
