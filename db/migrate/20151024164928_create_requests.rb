class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :organization_id, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.text :description_after_accept, null: true
      t.float :lat, null: false, index: true
      t.float :long, null: false, index: true
      t.integer :amount, null: false
      t.integer :timeout, null: false
      t.datetime :start
      t.datetime :end
      t.integer :range

      t.timestamps null: false
    end
    add_foreign_key :requests, :organizations, on_delete: :cascade
  end
end
