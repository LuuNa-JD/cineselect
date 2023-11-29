class FavoritesController < ApplicationController
  before_action :authenticate_user!

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

  def toggle
    favorite = current_user.favorites.find_by(tmdb_id: params[:tmdb_id])

    if favorite
      authorize favorite
      favorite.destroy
      favorited = false
    else
      favorite = current_user.favorites.build(favorite_params)
      authorize favorite
      favorite.save
      favorited = true
    end

    render json: { favorited: favorited }
  rescue Pundit::NotAuthorizedError => e
    render json: { error: e.message }, status: :forbidden
  end



  def create
    @favorite = Favorite.new(favorite_params)
    @favorite.user = current_user

    authorize @favorite

    if @favorite.save
      flash[:notice] = 'La séance a été ajoutée aux favoris.'
    else
      flash[:notice] = "La séance n'a pas été ajoutée aux favoris."
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
    params.permit(:tmdb_id, :title, :image_url, :media_type)
  end

  def api_key
    ENV['TMDB_API_KEY']
  end
end
