module PlatformHelper
  def map_watch_provider_to_id(provider_name)
    watch_providers = {
      'Netflix' => 8,
      'Amazon Prime Video' => 119,
      'Disney' => 337,
      'Apple' => 350,
      'Paramount Plus' => 531,
      'Crave' => 230,
    }
    watch_providers[provider_name]
  end


  def map_id_to_watch_provider(provider_id)
    id_to_watch_providers = {
      8 => 'Netflix',
      119 => 'Amazon Prime Video',
      337 => 'Disney',
      350 => 'Apple',
      531 => 'Paramount Plus',
      230 => 'Crave',
    }
    id_to_watch_providers[provider_id]
  end

  def set_user_streaming_ids
    @user_streaming_ids = current_user.selected_platforms.map do |platform_string|
      platform_hash = eval(platform_string)
      platform_hash[:id]
    end
  end



  def platform_logo(name)
    platform_logo_mapping = {
      "Netflix" => {
        "logo_path" => asset_path("netflix_logo.png"),
        "url" => "https://www.netflix.com/"
      },
      "Amazon Prime Video" => {
        "logo_path" => asset_path("amazon_prime_video_logo.png"),
        "url" => "https://www.primevideo.com/"
      },
      "Disney Plus" => {
        "logo_path" => asset_path("disney_logo.png"),
        "url" => "https://www.disneyplus.com/fr-fr"
      },
      "Apple TV Plus" => {
        "logo_path" => asset_path("apple_logo.png"),
        "url" => "https://www.apple.com/fr/apple-tv-plus/"
      },
      "Paramount Plus" => {
        "logo_path" => asset_path("paramount_plus_logo.png"),
        "url" => "https://www.paramountplus.com/"
      },
      "Crave" => {
        "logo_path" => asset_path("crave_logo.png"),
        "url" => "https://www.crave.ca/"
      },
    }


      if platform_logo_mapping.key?(name)
        platform = platform_logo_mapping[name]
        return link_to(image_tag(platform["logo_path"], alt: "#{name} Logo", class: "logo-image"), platform["url"])
      else
        return content_tag(:p, "Logo non trouvé pour #{name}")
    end
  end
end
