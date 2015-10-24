class CreateHelpers < ActiveRecord::Migration
  def change
    create_table :helpers, id: :uuid do |t|
      t.string :email, null: false, unique: true
      t.float :lat, null: false
      t.float :long, null: false

      t.timestamps null: false
    end
  end
end
