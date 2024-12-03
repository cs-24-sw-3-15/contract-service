class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.integer :supplier_number

      t.timestamps
    end
  end
end
