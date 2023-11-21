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
    authorize @seance
  end



  def create
    @api_key = "37051fb59364a8452b187291329bf015"
    @seance = Seance.new(seance_params)

      tmdb_service = ThemoviedbService.new(@api_key)
      preferences = { genre: @seance.genre }
      session[:movie_recommendations] = tmdb_service.recommend_movies(preferences).first(20)

      redirect_to seances_path, notice: 'Seance was successfully created.'

    authorize @seance
  end

  def edit
  end


  def update
    if @seance.update(seance_params)
      redirect_to @seance, notice: 'La séance a été mise à jour avec succès.'
    else
      render :edit
    end
  end


  def destroy
    @seance.destroy
    redirect_to seances_url, notice: 'La séance a été supprimée avec succès.'
  end

  private


  def set_seance
    @seance = Seance.find(params[:id])
  end


  def seance_params
    params.require(:seance).permit(:genre, :user_id) # Liste des attributs permis
  end

end
