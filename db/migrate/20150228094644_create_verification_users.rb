class CreateVerificationUsers < ActiveRecord::Migration
  def change
    create_table :verification_users do |t|
      t.integer :user_id
      t.string :verification_key
      t.boolean :verificated

      t.timestamps null: false
    end
  end
end
