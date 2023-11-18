class CreatePlatforms < ActiveRecord::Migration[7.0]
  def change
    create_table :platforms do |t|
      t.string :name
      t.integer :reelgood_service_id

      t.timestamps
    end
  end
end
