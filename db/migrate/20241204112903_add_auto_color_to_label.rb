class AddAutoColorToLabel < ActiveRecord::Migration[8.0]
  def change
    add_column :labels, :color_managed, :integer
  end
end
