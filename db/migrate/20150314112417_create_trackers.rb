class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :uuid, null:false,default:''
      t.string :api_token, null:false,default:''
      t.string :user_id, null:false
      t.string :car_id, null:false


      t.timestamps null: false
    end
    add_index :trackers, [:uuid,:user_id,:car_id], unique: true
    add_index :trackers, [:user_id,:car_id]
  end
end
