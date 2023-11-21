class UserPlatformsController < ApplicationController
  def new
    @user_platform = UserPlatform.new
    @platforms = Platform.all
    authorize @user_platform
  end

  def create
  @user_platform = UserPlatform.new(user_platform_params)
  authorize @user_platform

  @user_platform.user = current_user

  if @user_platform.save
    redirect_to new_seance_path, notice: "Plateforme enregistrer avec succes"
  else
    render :new
  end
end


  private

  def user_platform_params
    params.require(:user_platform).permit(:platform_id)
  end
end
