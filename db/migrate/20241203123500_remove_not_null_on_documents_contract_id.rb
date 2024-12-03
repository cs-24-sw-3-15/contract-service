class RemoveNotNullOnDocumentsContractId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :documents, :contract_id, true
  end
end
