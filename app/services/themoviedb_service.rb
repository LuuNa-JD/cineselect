require 'httparty'

class ThemoviedbService
  include HTTParty
  base_uri 'api.themoviedb.org/3'

  def initialize(api_key)
    @api_key = "37051fb59364a8452b187291329bf015"
  end

  def recommend_movies(preferences)
    query_params = { api_key: @api_key }
    query_params.merge!(map_preferences_to_query(preferences))
    response = self.class.get("/discover/movie", query: query_params)

    if response.success?
      movies = response.parsed_response["results"]
      movies.first(10)
    else
      []
    end
  end

  def get_streaming_info(movie_id)
    self.class.get("/movie/#{movie_id}/watch/providers", query: { api_key: @api_key })
  end


  private

  def map_preferences_to_query(preferences)
    query_params = {}

    # Mappage du genre
    if preferences[:genre].present?
      genre_id = get_genre_id(preferences[:genre])
      query_params[:with_genres] = genre_id if genre_id
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
  def get_genre_id(genre_name)
    genres = {
      "Action" => 28,
      "Aventure" => 12,
      "Animation" => 16,
      "Comédie" => 35,
      "Crime" => 80,
      "Documentaire" => 99,
      "Drame" => 18,
      "Familial" => 10751,
      "Fantastique" => 14,
      "Histoire" => 36,
      "Horreur" => 27,
      "Musique" => 10402,
      "Mystère" => 9648,
      "Romance" => 10749,
      "Science-Fiction" => 878,
      "Téléfilm" => 10770,
      "Thriller" => 53,
      "Guerre" => 10752,
      "Western" => 37
    }
    genres[genre_name]
  end
end
