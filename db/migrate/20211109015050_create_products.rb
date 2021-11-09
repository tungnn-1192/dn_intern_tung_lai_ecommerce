class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.decimal :price, null: false
      t.float :rating, default: 0
      t.integer :inventory, null: false
      t.string :unit, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
