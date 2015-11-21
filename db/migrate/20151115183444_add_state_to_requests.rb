class AddStateToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :state, :string, null: false, default: "pending"
  end
end
