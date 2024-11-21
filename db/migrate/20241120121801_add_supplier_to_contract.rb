class AddSupplierToContract < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :supplier_id, :integer, null: false
  end
end
