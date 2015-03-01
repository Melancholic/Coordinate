class CreateResetPasswords < ActiveRecord::Migration
  def change
    create_table :reset_passwords do |t|
      t.belongs_to :user, index: true
      t.string :password_key, null: false
      t.string :host


      t.timestamps null: false
    end
  end
end
