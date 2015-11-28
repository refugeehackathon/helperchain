class RenameCharityToIsPublic < ActiveRecord::Migration
  def change
    rename_column :projects, :charity, :is_public
  end
end
