class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :user, index: true, null:false
      t.belongs_to :image
      t.string :name
      t.string :second_name
      t.string :middle_name
      t.string :mobile_phone
      t.string :country 
      t.string :region
      t.string :city
      t.timestamps null: false
    end

  end
end
