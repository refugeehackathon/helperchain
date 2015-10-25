class AddedRequestStatusUniqueUserRequestIndex < ActiveRecord::Migration
  def change
    add_index :request_statuses, [:helper_id, :request_id], :unique => true
  end
end
