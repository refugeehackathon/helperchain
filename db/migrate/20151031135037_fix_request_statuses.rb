class FixRequestStatuses < ActiveRecord::Migration
  def change
    change_column :request_statuses, :accepted, :boolean , null: true
    change_column_default :request_statuses, :accepted, nil
  end
end
