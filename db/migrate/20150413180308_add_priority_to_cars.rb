class AddPriorityToCars < ActiveRecord::Migration
  def change
    add_column :cars, :priority, :integer, limit: 1, null: false, default: 5;
1
  end
end
