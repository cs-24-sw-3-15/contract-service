class DropCompanies < ActiveRecord::Migration[8.0]
  def change
    drop_table :companies
  end
end
