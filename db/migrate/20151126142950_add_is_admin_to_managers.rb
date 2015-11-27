class AddIsAdminToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :is_admin, :boolean, null: false, default: true
  end
end
