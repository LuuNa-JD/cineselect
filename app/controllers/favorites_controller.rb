class FavoritesController < ApplicationController

  def index
    # tmdb_service = ThemoviedbService.new(api_key)
    # @favorites_details = current_user.favorites.map do |favorite|
    #   detail = if favorite.media_type == 'film'
    #             tmdb_service.get_movie_details(favorite.tmdb_id)
    #           elsif favorite.media_type == 'series'
    #             tmdb_service.get_series_details(favorite.tmdb_id)
    #           end

    #   logger.debug "Favorite detail for tmdb_id #{favorite.tmdb_id}: #{detail.inspect}"
    #   detail
    # end.compact
    @favorites = Favorite.where(user: current_user)
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

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    authorize @favorite
    redirect_to favorites_path, notice: 'votre film a été supprimé de vos favoris'
  end

  private

  def favorite_params
    params.permit(:tmdb_id, :media_type, :title, :image_url)
  end


  def api_key
    ENV['TMDB_API_KEY']
  end
end
