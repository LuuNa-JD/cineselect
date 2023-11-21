require 'httparty'

class ThemoviedbService
  include HTTParty
  base_uri 'api.themoviedb.org/3'
  debug_output $stdout

  def initialize(api_key)
    @api_key = api_key
  end

  def recommend_movies(preferences, watch_provider, watch_region, sort_by = 'popularity.desc')
    query_params = { api_key: @api_key, sort_by: sort_by, watch_region: watch_region }
    query_params.merge!(map_preferences_to_query(preferences))
    query_params[:with_watch_providers] = map_watch_provider_to_id(watch_provider) if watch_provider.present?

    response = self.class.get("/discover/movie", query: query_params)

    if response.success?
      movies = response.parsed_response["results"]
      movies.first(10)
    else
      []
    end
  end

  def recommend_series(preferences, watch_provider = nil, watch_region = nil, sort_by = 'popularity.desc')
    query_params = { api_key: @api_key, sort_by: sort_by, watch_region: watch_region }
    query_params.merge!(map_preferences_to_query(preferences))
    query_params[:with_watch_providers] = map_watch_provider_to_id(watch_provider) if watch_provider.present?

    response = self.class.get("/discover/tv", query: query_params)

    if response.success?
      series = response.parsed_response["results"]
      series.first(10)
    else
      []
    end
  end

  # def get_streaming_info(movie_id)
  #   self.class.get("/movie/#{movie_id}/watch/providers", query: { api_key: @api_key })
  # end

  def get_all_genres
    response = self.class.get("/genre/movie/list", query: { api_key: @api_key })
    if response.success?
      response.parsed_response["genres"].map { |genre| [genre["name"], genre["id"]] }
    else
      []
    end
  end

  def map_watch_provider_to_id(provider_name)
    watch_providers = {
      'Netflix' => '8',
      'Amazon Prime Video' => '9',
      'Disney+' => '337'
    }
    watch_providers[provider_name]
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

  def map_preferences_to_query(preferences)
    query_params = {}

    # Mappage du genre
    query_params[:with_genres] = preferences[:genre] if preferences[:genre].present?

    # Mappage des mots-clés
    if preferences[:keyword].present?
      keyword_ids = map_keywords_to_ids(preferences[:keyword])
      query_params[:with_keywords] = keyword_ids.join(',') if keyword_ids.any?
    end

    # Mappage de l'acteur
    if preferences[:actor].present?
      actor_id = get_person_id(preferences[:actor])
      query_params[:with_cast] = actor_id if actor_id
    end

    # Mappage de l'année
    if preferences[:year].present?
      query_params[:year] = preferences[:year]
    end

    query_params
  end

  def api_key
    ENV['TMDB_API_KEY']
  end
end
