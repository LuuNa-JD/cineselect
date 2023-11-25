class AddTmdb < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :tmdb_id, :string
  end
end
