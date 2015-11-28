class RemoveTimeoutFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :timeout, :integer
  end
end
