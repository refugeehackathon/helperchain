class AddVerificationToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :is_verified, :boolean, null: false, default: false
  end
end
