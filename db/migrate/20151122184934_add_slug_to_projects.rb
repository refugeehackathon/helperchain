class AddSlugToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :slug, :string
    Project.all.each do |p|
      p.slug = p.name.parameterize
      p.save
    end
    change_column :projects, :slug, :string, null: false
    add_index :projects, :slug, unique: true
  end
end
