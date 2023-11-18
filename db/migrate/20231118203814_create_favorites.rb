class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :reelgood_id
      t.integer :variety
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
