class AddWatchRegionToSeances < ActiveRecord::Migration[7.0]
  def change
    add_column :seances, :watch_region, :string
  end
end
