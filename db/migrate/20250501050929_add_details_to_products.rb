class AddDetailsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :image, :string
    add_column :products, :description, :text
    add_column :products, :price, :decimal
    add_reference :products, :category, foreign_key: true
    add_reference :products, :admin, foreign_key: true
  end
end
