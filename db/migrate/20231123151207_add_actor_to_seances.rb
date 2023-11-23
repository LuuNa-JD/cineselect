class AddActorToSeances < ActiveRecord::Migration[7.0]
  def change
    add_column :seances, :actor, :string
  end
end
