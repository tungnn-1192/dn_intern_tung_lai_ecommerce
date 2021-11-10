class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :telephone
      t.string :address
      t.date :birthday
      t.boolean :gender
      t.integer :role, default: 0
      t.string :password_digest
      t.string :remember_digest

      t.timestamps
    end
  end
end
