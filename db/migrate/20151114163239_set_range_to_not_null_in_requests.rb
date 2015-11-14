class SetRangeToNotNullInRequests < ActiveRecord::Migration
  def change
    change_column :requests, :range, :integer, null: false, default: 10
  end
end
