class AddIndexTitleUserIdToCars < ActiveRecord::Migration
  def change
    add_index :cars, [:title,:user_id], unique: true
  end
end
