require 'httparty'

class ThemoviedbService
  include HTTParty
  include PlatformHelper

  base_uri 'api.themoviedb.org/3'
  debug_output $stdout

  def initialize(api_key)
    @api_key = api_key
  end

  def recommend_movies(preferences, user, watch_region, watch_provider_ids, sort_by = 'popularity.desc')
    query_params = {
      api_key: @api_key,
      sort_by: sort_by,
      watch_region: watch_region,
      with_watch_providers: watch_provider_ids.join('|')
    }

    query_params.merge!(map_preferences_to_query(preferences))
    response = self.class.get("/discover/movie", query: query_params)

    if response.success?
      movies = response.parsed_response["results"]
      movies.first(20)
    else
      []
    end
  end

  def recommend_series(preferences, user, watch_region, watch_provider_ids, sort_by = 'popularity.desc')
    query_params = {
      api_key: @api_key,
      sort_by: sort_by,
      watch_region: watch_region,
      with_watch_providers: watch_provider_ids.join('|')
    }

    query_params.merge!(map_preferences_to_query(preferences))
    response = self.class.get("/discover/tv", query: query_params)

    if response.success?
      series = response.parsed_response["results"]
      series.first(20)
    else
      []
    end
  end

  def get_movie_details(movie_id)
    response = self.class.get("/movie/#{movie_id}", query: { api_key: @api_key })
    response.success? ? response.parsed_response : nil
  end

  def get_series_details(series_id)
    response = self.class.get("/tv/#{series_id}", query: { api_key: @api_key })
    response.success? ? response.parsed_response : nil
  end

  def get_all_genres
    response = self.class.get("/genre/movie/list", query: { api_key: @api_key })
    if response.success?
      response.parsed_response["genres"].map { |genre| [genre["name"], genre["id"]] }
    else
      []
    end
  end

  def get_popular_actors
    response = self.class.get("/person/popular", query: { api_key: @api_key })
    if response.success?
      response.parsed_response["results"].map { |actor| [actor["name"], actor["id"]] }
    else
      []
    end
  end

  def get_countries
    response = self.class.get("/configuration/countries", query: { api_key: @api_key })
    if response.success?
      countries_data = response.parsed_response
      country_names = countries_data.map { |country| [country['english_name'], country['iso_3166_1']] }
      return country_names
    else
      return []
    end
  end

  # def map_watch_provider_to_id(provider_name)
  #   watch_providers = {
  #     'Netflix' => 8,
  #     'Amazon Prime Video' => 119,
  #     'Disney+' => 337
  #   }
  #   watch_providers[provider_name]
  # end

  def get_streaming_providers(item_id, type)
    response = self.class.get("/#{type}/#{item_id}/watch/providers", query: { api_key: @api_key })
    if response.success? && response.parsed_response['results']
      response.parsed_response['results'].each_with_object([]) do |(_country, data), array|
        next unless data['flatrate']

        data['flatrate'].each do |provider|
          array << { "provider_id" => provider["provider_id"].to_s, "name" => provider["provider_name"] }
        end
      end
    else
      []
    end
  end


  private


  def map_keywords_to_ids(keyword)
    keyword_ids = []
    keyword.split(',').each do |keyword|
      response = self.class.get("/search/keyword", query: { api_key: @api_key, query: keyword.strip })
      if response.success? && response.parsed_response["results"].any?
        keyword_ids << response.parsed_response["results"].first["id"]
      end
    end
    keyword_ids
  end

    # Mappage Generale
  def map_preferences_to_query(preferences)
    query_params = {}

    # Mappage du genre
    query_params[:with_genres] = preferences[:genre] if preferences[:genre].present?

    # Mappage des mots-clés
    if preferences[:keyword].present?
      keyword_ids = map_keywords_to_ids(preferences[:keyword])
      query_params[:with_keywords] = keyword_ids.join(',') if keyword_ids.any?
    end

    # Mappage des pays d'origine
    query_params[:with_origin_country] = preferences[:origin_country] if preferences[:origin_country].present?

    # Mappage de la durée
    query_params['with_runtime.lte'] = preferences[:runtime] if preferences[:runtime].present?

    # # Mappage de l'acteur
    query_params[:with_cast] = preferences[:actor] if preferences[:actor].present?

    # # Mappage de l'année
    query_params[:year] = preferences[:year] if preferences[:year].present?

    query_params
  end

  def api_key
    ENV['TMDB_API_KEY']
  end
end
