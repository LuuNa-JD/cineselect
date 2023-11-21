class AddDetailsToSeances < ActiveRecord::Migration[7.0]
  def change
    add_column :seances, :keyword, :string
  end
end
