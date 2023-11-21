class AddWatchProviderToSeances < ActiveRecord::Migration[7.0]
  def change
    add_column :seances, :watch_provider, :string
  end
end
