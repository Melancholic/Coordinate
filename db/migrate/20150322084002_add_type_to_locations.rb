class AddTypeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :state, :string, default:'Location', null:false;
    add_column :locations, :accuracy, :float
    add_column :locations, :speed, :float
    add_column :locations, :time, :datetime
    add_column :locations, :track_id, :integer;

   add_index :locations, [:track_id, :latitude, :longitude, :time], unique:true, name:'track_id_lat_long_time_index'

  end
end
