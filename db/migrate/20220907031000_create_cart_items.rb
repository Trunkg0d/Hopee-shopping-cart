class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :cart_session
      t.references :product
      t.integer :quantity
      t.string :size
      t.timestamps
    end
  end
end
