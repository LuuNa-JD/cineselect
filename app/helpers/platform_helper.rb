module PlatformHelper
  def map_watch_provider_to_id(provider_name)
    watch_providers = {
      'Netflix' => 8,
      'Amazon Prime Video' => 119,
      'Disney+' => 337
    }
    watch_providers[provider_name]
  end


  def map_id_to_watch_provider(provider_id)
    id_to_watch_providers = {
      8 => 'Netflix',
      119 => 'Amazon Prime Video',
      337 => 'Disney+'
    }
    id_to_watch_providers[provider_id]
  end
end
