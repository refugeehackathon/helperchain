class RenameOrganizationToProject < ActiveRecord::Migration
  def change
    remove_foreign_key :requests, :organizations
    remove_foreign_key :orga_members, :organizations
    rename_table :orga_members, :managers
    rename_table :organizations, :projects
    rename_column :managers, :organization_id, :project_id
    rename_column :requests, :organization_id, :project_id
    add_foreign_key :requests, :projects, on_delete: :cascade
    add_foreign_key :managers, :projects, on_delete: :cascade
  end
end
