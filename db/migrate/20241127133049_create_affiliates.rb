class CreateAffiliates < ActiveRecord::Migration[8.0]
  def change
    create_table :affiliates do |t|
      t.string :name
      t.integer :stake

      t.timestamps
    end
  end
end
