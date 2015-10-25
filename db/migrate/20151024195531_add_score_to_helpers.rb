class AddScoreToHelpers < ActiveRecord::Migration
  def change
    add_column :helpers, :score, :integer, null: false, default: 100
  end
end
