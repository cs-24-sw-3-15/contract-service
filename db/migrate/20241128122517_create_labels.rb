class CreateLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :labels do |t|
      t.string :title, null: false
      t.string :tag, null: false
      t.string :color, limit: 7

      t.string :ancestry, null: false
      t.index :ancestry

      t.timestamps
    end
  end
end
