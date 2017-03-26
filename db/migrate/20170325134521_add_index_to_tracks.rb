class AddIndexToTracks < ActiveRecord::Migration[5.0]
  def change
    add_index :tracks, :car_id
  end
end
