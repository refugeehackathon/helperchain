class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations, id: :uuid do |t|
      enable_extension 'uuid-ossp'
      t.string :name, index: true, null: false

      t.timestamps null: false
    end
  end
end
