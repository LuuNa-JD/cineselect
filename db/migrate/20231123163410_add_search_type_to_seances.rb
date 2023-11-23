class AddSearchTypeToSeances < ActiveRecord::Migration[7.0]
  def change
    add_column :seances, :search_type, :string
  end
end
