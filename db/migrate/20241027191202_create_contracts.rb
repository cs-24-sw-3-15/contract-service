class CreateContracts < ActiveRecord::Migration[7.2]
  def change
    create_table :contracts do |t|
      t.string :title

      t.timestamps
    end
  end
end
