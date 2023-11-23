class UserPlatformsController < ApplicationController
  def new
    @platforms = Platform.all
    @user_platform = UserPlatform.new
    authorize @user_platform
  end

  def create
    @user_platform = UserPlatform.new(user_platform_params)
    @user_platform.user = current_user
    authorize @user_platform

    if @user_platform.save
      redirect_to root_path, notice: "Plateforme enregistrée avec succès"
    else
      @platforms = Platform.all
      flash.now[:alert] = "Vous avez déjà enregistré cette plateforme"
      render :new
    end
  end

  private

  def user_platform_params
    params.require(:user_platform).permit(:platform_id)
  end
end
