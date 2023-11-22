class AddSelectedPlatformsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :selected_platforms, :text, array: true, default: []
  end
end
