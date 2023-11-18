class CreateSeances < ActiveRecord::Migration[7.0]
  def change
    create_table :seances do |t|
      t.string :genre
      t.string :origin_country
      t.date :release_date
      t.string :distributor
      t.integer :runtime
      t.integer :variety
      t.string :tag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
