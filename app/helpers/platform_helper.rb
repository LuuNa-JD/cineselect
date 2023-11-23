module PlatformHelper
  def map_watch_provider_to_id(provider_name)
    watch_providers = {
      'Netflix' => 8,
      'Amazon Prime Video' => 119,
      'Disney' => 337
    }
    watch_providers[provider_name]
  end


  def map_id_to_watch_provider(provider_id)
    id_to_watch_providers = {
      8 => 'Netflix',
      119 => 'Amazon Prime Video',
      337 => 'Disney'
    }
    id_to_watch_providers[provider_id]
  end

  def set_user_streaming_ids
    @user_streaming_ids = current_user.selected_platforms.map do |platform_string|
      platform_hash = eval(platform_string)
      platform_hash[:id]
    end
  end
end
