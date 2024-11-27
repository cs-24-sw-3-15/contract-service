class AddDatesToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :start_date, :date
    add_column :contracts, :end_date, :date
  end
end
