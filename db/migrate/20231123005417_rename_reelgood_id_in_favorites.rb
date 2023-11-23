class RenameReelgoodIdInFavorites < ActiveRecord::Migration[7.0]
  def change
    rename_column :favorites, :reelgood_id, :tmdb_id
  end
end
