class ModifyFavoritesTable < ActiveRecord::Migration[7.0]
  def change
        remove_column :favorites, :variety
        remove_column :favorites, :tmdb_id

        add_column :favorites, :title, :string
        add_column :favorites, :image_url, :string
  end
end
