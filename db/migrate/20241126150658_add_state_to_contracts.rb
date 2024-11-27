class AddStateToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :state, :string
  end
end
