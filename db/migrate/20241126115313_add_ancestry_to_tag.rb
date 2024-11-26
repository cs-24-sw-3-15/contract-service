class AddAncestryToTag < ActiveRecord::Migration[8.0]
  def change
    add_column :tags, :ancestry, :string
    add_index :tags, :ancestry
  end
end
