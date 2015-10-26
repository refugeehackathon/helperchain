class AddUniqueKeysToHelpers < ActiveRecord::Migration
  def change
    add_index :helpers, :email, unique: true
    add_index :helpers, :confirmation_key, unique: true
  end
end
