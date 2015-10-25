class AddConfirmationKeyToHelpers < ActiveRecord::Migration
  def change
    add_column :helpers, :confirmation_key, :string, unique: true
    add_column :helpers, :validated, :boolean, null: false, default: false
  end
end
