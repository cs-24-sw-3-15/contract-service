class CreateAffiliates < ActiveRecord::Migration[8.0]
  def change
    create_table :affiliates do |t|
      t.timestamps
    end
  end
end
