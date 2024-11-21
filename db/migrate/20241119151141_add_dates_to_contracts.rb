class AddDatesToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :start_date, :date, null: false
    add_column :contracts, :expiration_date, :date
  end
end
