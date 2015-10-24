class CreateRequestStatuses < ActiveRecord::Migration
  def change
    create_table :request_statuses, id: :uuid do |t|
      t.uuid :request_id, index: true, null: false
      t.uuid :helper_id, index: true, null: false
      t.boolean :accepted, null: true
      t.boolean :timeout, null: false, default: false

      t.timestamps null: false
    end
    add_foreign_key :request_statuses, :requests, on_delete: :cascade
    add_foreign_key :request_statuses, :helpers, on_delete: :cascade
  end
end
