class CreateFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :folders do |t|
      t.string :name

      t.string :ancestry, null: false
      t.index :ancestry

      t.timestamps
    end
  end
end
