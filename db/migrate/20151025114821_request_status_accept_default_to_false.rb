class RequestStatusAcceptDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :request_statuses, :accepted, :boolean, null: false, default: false
  end
end
