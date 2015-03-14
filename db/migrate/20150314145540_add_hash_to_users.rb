class AddHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_hash, :string, unique: true
  end
end
