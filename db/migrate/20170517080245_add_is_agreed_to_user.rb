class AddIsAgreedToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_agreed, :boolean, default: false, null: false
    add_column :users, :agreed_at, :datetime
  end
end
