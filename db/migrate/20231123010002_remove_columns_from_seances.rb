class RemoveColumnsFromSeances < ActiveRecord::Migration[7.0]
  def change
    remove_column :seances, :variety
    remove_column :seances, :tag

  end
end
