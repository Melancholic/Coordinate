class AddTrackerUuidToCars < ActiveRecord::Migration
  def change
    add_column :cars, :tracker_uuid, :string
    add_index :cars, :tracker_uuid,unique: true
  end
end
