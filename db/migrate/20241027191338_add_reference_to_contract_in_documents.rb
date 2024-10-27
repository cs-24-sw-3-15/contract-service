class AddReferenceToContractInDocuments < ActiveRecord::Migration[7.2]
  def change
    add_reference :documents, :contract, null: false, foreign_key: true
  end
end
