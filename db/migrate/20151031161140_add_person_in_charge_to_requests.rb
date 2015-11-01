class AddPersonInChargeToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :member_in_charge_id, :integer, null: false
    add_foreign_key :requests, :orga_members, column: :member_in_charge_id, on_delete: :cascade
  end
end
