class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :item_number
      t.string :item_description
      t.string :item_status
      t.string :category
      t.string :sale_type

      t.timestamps
    end
  end
end
