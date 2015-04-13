class AddColorToCars < ActiveRecord::Migration
  def change
    add_column :cars, :color, :string, null:false, default: "FF0000"
  end
end
