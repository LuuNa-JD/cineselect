class FavoritesController < ApplicationController

  def index
    tmdb_service = ThemoviedbService.new(api_key)
    @favorites_details = current_user.favorites.map do |favorite|
      detail = if favorite.media_type == 'film'
                tmdb_service.get_movie_details(favorite.tmdb_id)
              elsif favorite.media_type == 'series'
                tmdb_service.get_series_details(favorite.tmdb_id)
              end

      logger.debug "Favorite detail for tmdb_id #{favorite.tmdb_id}: #{detail.inspect}"
      detail
    end.compact
  end


  def create
    @favorite = Favorite.new(favorite_params)
    @favorite.user = current_user

    authorize @favorite

    if @favorite.save
      redirect_to root_path, notice: 'La séance a été ajoutée aux favoris.'
    else
      render :new
    end
  end

  private

  def favorite_params
    params.permit(:tmdb_id, :media_type)
  end


  def api_key
    ENV['TMDB_API_KEY']
  end
end
