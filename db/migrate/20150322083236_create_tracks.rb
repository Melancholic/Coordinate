class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.datetime :start_time
      t.datetime :stop_time
      t.integer :car_id, null:false

      t.timestamps null: false
    end
  end
end
