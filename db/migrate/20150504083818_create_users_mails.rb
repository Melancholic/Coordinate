class CreateUsersMails < ActiveRecord::Migration
  def change
    create_table :users_mails do |t|
      t.string :first_name, null:false
      t.string :last_name
      t.string :email, null:false
      t.string :subject, null:false
      t.string :message, null:false, limit:1000
      t.boolean :opened, default:true
      t.references :user
      t.string :host, limit:15
      t.timestamps null: false
    end
  end
end
