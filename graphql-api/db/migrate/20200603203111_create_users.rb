class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :auth_token
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :auth_token, unique: true
  end
end
