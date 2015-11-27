class AddInviteKeyToProjects < ActiveRecord::Migration
  require 'securerandom'
  def change
    add_column :projects, :invite_key, :string
  end
end
