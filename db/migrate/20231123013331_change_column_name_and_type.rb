class ChangeColumnNameAndType < ActiveRecord::Migration[7.0]
  def change
    rename_column :seances, :release_date, :year
  end
end
