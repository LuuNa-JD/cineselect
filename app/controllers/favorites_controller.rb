class FavoritesController < ApplicationController

  def index
    tmdb_service = ThemoviedbService.new(api_key)
    @favorites_movies = []
    @favorites_series = []

    current_user.favorites.each do |favorite|
      detail = favorite.media_type == 'film' ? tmdb_service.get_movie_details(favorite.tmdb_id) : tmdb_service.get_series_details(favorite.tmdb_id)
      if detail
        detail[:tmdb_id] = favorite.tmdb_id
        detail[:favorite_id] = favorite.id
        detail[:media_type] = favorite.media_type

        if favorite.media_type == 'film'
          @favorites_movies << detail
        else
          @favorites_series << detail
        end
      end
    end
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
    authorize @favorite

    if @favorite.destroy
      redirect_to favorites_path, notice: 'Le favori a été supprimé avec succès.'
    else
      redirect_to favorites_path, alert: 'Une erreur s\'est produite lors de la suppression du favori.'
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

def normalize_data(detail, media_type)
  case media_type
  when 'film'

    {
      title: detail['title'],
      overview: detail['overview'],
      poster_path: detail['poster_path'],
      release_date: detail['release_date']

    }
  when 'series'

    {
      title: detail['name'],
      overview: detail['overview'],
      poster_path: detail['poster_path'],
      first_air_date: detail['first_air_date']

    }
  end
end
