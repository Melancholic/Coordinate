class RemoveStateFromLocations < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :state, :string
  end
end
