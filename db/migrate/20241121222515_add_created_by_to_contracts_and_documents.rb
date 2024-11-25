class AddCreatedByToContractsAndDocuments < ActiveRecord::Migration[8.0]
  def change
    add_reference :contracts, :created_by, null: false, foreign_key: { to_table: :users }
    add_reference :documents, :created_by, null: false, foreign_key: { to_table: :users }
  end
end
