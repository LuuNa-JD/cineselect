class RemoveColumnsWatchRegionFromSeances < ActiveRecord::Migration[7.0]
  def change
    remove_column :seances, :watch_region
    remove_column :seances, :watch_provider
  end
end
