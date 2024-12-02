class AddSupplierAndAffiliateRefToContracts < ActiveRecord::Migration[6.0]
  def change
    add_reference :contracts, :supplier, null: true, foreign_key: true
    add_reference :contracts, :affiliate, null: true, foreign_key: true
  end
end
