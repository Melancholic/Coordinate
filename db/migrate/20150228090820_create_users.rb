class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, null:false
      t.string :email, null:false
      t.string :password_digest
      t.string :remember_token
      t.timestamps null:false
      t.boolean :admin, default:false
      #Добавление уникального ключа
    end
    add_index(:users, :email, unique: true);
    add_index :users, :remember_token;
  end
end
