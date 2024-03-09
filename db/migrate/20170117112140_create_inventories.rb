class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
    	t.string  :inventory_type
			t.integer :item_number
			t.integer :org_number
			t.integer :quantity
			t.string  :status
			t.date    :last_ship_date
			t.date    :due_date
			t.integer :lot

      t.timestamps
    end
  end
end
