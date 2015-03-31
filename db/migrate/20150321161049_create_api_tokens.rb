class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.integer :car_id, index:true
      t.string :token,null:false
      t.timestamps null: false
    end
  end
end
