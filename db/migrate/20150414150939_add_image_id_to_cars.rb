class AddImageIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :image_id, :integer
  end
end
