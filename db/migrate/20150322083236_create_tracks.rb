class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.time :start_time
      t.time :stop_time
      t.integer :car_id

      t.timestamps null: false
    end
  end
end
