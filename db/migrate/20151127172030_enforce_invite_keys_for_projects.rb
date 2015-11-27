class EnforceInviteKeysForProjects < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      project.generate_invite_key
      project.save
    end
    change_column :projects, :invite_key, :string, null: false
  end
  def down
    change_column :projects, :invite_key, :string, null: true
  end
end
