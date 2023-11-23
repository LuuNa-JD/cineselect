class ChangeColumnNameReelgooServiceIdToProviderId < ActiveRecord::Migration[7.0]
  def change
    rename_column :platforms, :reelgood_service_id, :provider_id
  end
end
