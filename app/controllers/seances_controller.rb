class SeancesController < ApplicationController

  def index
    @seances = Seance.all
    authorize @seances
  end


  def show
    @seance = Seance.find(params[:id])
    @user_platforms = UserPlatform.where(user: current_user)
    @favorites = Favorite.where(user: current_user)
    @movie_recommendations = session[:movie_recommendations]
    authorize @seance
  end


  def new
    @seance = Seance.new
    @genres = fetch_genres
    authorize @seance
  end



  def create
    @seance = Seance.new(seance_params)
    tmdb_service = ThemoviedbService.new(api_key)
    preferences = build_preferences_hash(params[:seance])

    query_params = {}

    watch_provider_name = params[:seance][:watch_provider]
    watch_region = params[:seance][:watch_region]

    watch_provider_id = tmdb_service.map_watch_provider_to_id(watch_provider_name)
    query_params[:with_watch_providers] = watch_provider_id if watch_provider_id.present?


    if params[:seance][:seance_type] == 'Film'
      session[:recommendations] = tmdb_service.recommend_movies(preferences, watch_provider_name, watch_region).first(10)
    elsif params[:seance][:seance_type] == 'Série'
      session[:recommendations] = tmdb_service.recommend_series(preferences, watch_provider_name, watch_region).first(10)
    end

    redirect_to seances_path, notice: 'Seance was successfully created.'
    authorize @seance
  end


  private

  def fetch_genres
    tmdb_service = ThemoviedbService.new(api_key)
    tmdb_service.get_all_genres
  end

  def build_preferences_hash(seance_params)
    {
      genre: seance_params[:genre],
      keyword: seance_params[:keyword],
      actor: seance_params[:actor],
      year: seance_params[:year]
    }
  end

  def api_key
    ENV['TMDB_API_KEY']
  end

  def set_seance
    @seance = Seance.find(params[:id])
  end


  def seance_params
    params.require(:seance).permit(:genre, :keyword, :user_id, :seance_type, :watch_provider, :watch_region)
  end

  def map_watch_provider_to_id(provider_name)
    watch_providers = {
      'Netflix' => 8,
      'Amazon Prime Video' => 9,
      'Disney+' => 337
    }
    watch_providers[provider_name]
  end


end
