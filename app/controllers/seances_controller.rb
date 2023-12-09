require 'httparty'

class SeancesController < ApplicationController
  include PlatformHelper

  def index
    @seances = Seance.all
    authorize @seances
  end

  def show
    item_id = params[:id]
    tmdb_service = ThemoviedbService.new(api_key)
    seance_type = params[:type]

    if seance_type == 'film'
      @item_details = tmdb_service.get_movie_details(item_id)
      if @item_details
        authorize :movie, :show?
      else
        redirect_to seances_path, alert: "Ce film n'existe pas."
        return
      end
    elsif seance_type == 'serie'
      @item_details = tmdb_service.get_series_details(item_id)
      if @item_details
        authorize :series, :show?
      else
        redirect_to seances_path, alert: "Cette série n'existe pas."
        return
      end
    else
      authorize :seance, :show?
      redirect_to seances_path, alert: "Type de média non spécifié ou non valide."
      return
    end
    @item_in_favorites = Favorite.find_by(tmdb_id: @item_details["id"], user_id: current_user.id)

  end



  def new
    @seance = Seance.new
    flash.now[:alert] = flash[:alert] if flash[:alert].present?
    @genres = fetch_genres
    @origin_country = fetch_origin_countries
    @actors = fetch_popular_actors
    @runtime = []
    authorize @seance
  end



  def create
    @seance = Seance.new(seance_params)
    tmdb_service = ThemoviedbService.new(api_key)
    preferences = build_preferences_hash(params[:seance])
    user = current_user
    user_region = detect_user_region
    authorize @seance
    query_params = {}

    watch_region = params[:seance][:watch_region]

    watch_provider_ids = user.selected_platforms.map do |platform|
      hash = eval(platform)
      hash[:id]
    end

    if params[:seance][:seance_type].blank?
      redirect_to new_seance_path, flash: { alert: "Veuillez sélectionner un type de média (Film ou Série)." }
      return
    end

    if params[:seance][:seance_type] == 'Film'
      session[:recommendations] = tmdb_service.recommend_movies(preferences, user, user_region, watch_provider_ids).first(20).map do |recommendation|
        recommendation.merge({ "media_type" => "film" })
      end
    elsif params[:seance][:seance_type] == 'Série'
      session[:recommendations] = tmdb_service.recommend_series(preferences, user, user_region, watch_provider_ids).first(20).map do |recommendation|
        recommendation.merge({ "media_type" => "serie" })
      end
    end

    if session[:recommendations].nil? || session[:recommendations].empty?
      redirect_to new_seance_path, flash: { alert: "Nous n'avons pas trouvé votre bonheur... Veuillez réessayer" }
      return
    end
    watch_providers_param = watch_provider_ids.join('|')

    redirect_to seances_path
  end


  def show_streaming_platforms
    item_id = params[:id]
    seance_type = params[:type] == 'film' ? 'movie' : 'tv'
    tmdb_service = ThemoviedbService.new(api_key)

    @item_details = seance_type == 'movie' ? tmdb_service.get_movie_details(item_id) : tmdb_service.get_series_details(item_id)

    if @item_details
      @streaming_providers = tmdb_service.get_streaming_providers(item_id, seance_type)

      user_streaming_ids = current_user.selected_platforms.map do |platform_string|
        platform_hash = eval(platform_string)
        platform_hash[:id]
      end

      @available_platforms = @streaming_providers.select do |provider|
        user_streaming_ids.include?(provider["provider_id"].to_i)
      end

      @available_platforms.uniq! { |platform| platform["provider_id"] }
      authorize Seance
    else
      redirect_to seances_path, alert: 'Détails non trouvés.'
      return
    end
  end

  def search_actors
    search_query = params[:query]
    tmdb_service = ThemoviedbService.new(ENV['TMDB_API_KEY'])
    actors = tmdb_service.search_actors(query)
    render json: actors
  end


  private


  def fetch_genres
    tmdb_service = ThemoviedbService.new(api_key)
    tmdb_service.get_all_genres
  end

  def fetch_popular_actors
    tmdb_service = ThemoviedbService.new(api_key)
    tmdb_service.get_popular_actors
  end

  def fetch_origin_countries
    tmdb_service = ThemoviedbService.new(api_key)
    tmdb_service.get_countries
  end

  def build_preferences_hash(seance_params)
    {
      genre: seance_params[:genre],
      runtime: seance_params[:runtime],
      keyword: seance_params[:keyword],
      actor: seance_params[:actor],
      year: seance_params[:year],
      origin_country: seance_params[:origin_country],
    }
  end

  def api_key
    ENV['TMDB_API_KEY']
  end

  def set_seance
    @seance = Seance.find(params[:id])
  end


  def seance_params
    params.require(:seance).permit(:genre, :keyword, :user_id, :seance_type, :actor, :year, :watch_region, :runtime, :origin_country)
  end



  def detect_user_region
    response = HTTParty.get("https://ipapi.co/json/")
    if response.success?
      JSON.parse(response.body)['country_code']
    else
      'US'
    end
  end
end
