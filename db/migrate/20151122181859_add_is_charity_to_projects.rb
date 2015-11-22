class AddIsCharityToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :charity, :boolean, null: false, default: true
  end
end
