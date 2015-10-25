class RenameUsersToOrgaMembers < ActiveRecord::Migration
  def change
    rename_table :users, :orga_members
  end
end
