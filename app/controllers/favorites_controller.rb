class FavoritesController < ApplicationController


  def new
    redirect_to new_favorite_path
    authorize Seance
    @user = current_user
    @favorite = Favorite.new
  end

  def create
    @favorite = Favorite.new(seance_params)


    if @favorite.save
      redirect_to root_path, notice: 'La séance a été ajoutée aux favoris.'
    else
      render :new
    end
  end

  def show
    favorite = favorite.find(params[:id])
  end

  def index
    @favorites = current_user.favorites.map(&:movie_id)

  def edit

  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    redirect_to favorites_path, notice: 'Le favori a été supprimé.'
    end

    private

    def seance_params
      params.require(:seance).permit(:movie_id, :series_id)
    end

  end
end
