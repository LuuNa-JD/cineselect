class AddMediaTypeToFavorites < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :media_type, :string
  end
end
