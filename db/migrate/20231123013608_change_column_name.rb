class ChangeColumnName < ActiveRecord::Migration[7.0]
  def change
    remove_column :seances, :year
    add_column :seances, :year, :integer
  end
end
