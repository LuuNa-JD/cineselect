class UserPlatformsController < ApplicationController
  include PlatformHelper

  def new
    @user_platform = UserPlatform.new
    set_user_streaming_ids
    @platforms = Platform.all
    authorize @user_platform
  end

  def create
    platform_names = params[:user][:selected_platforms].reject(&:blank?)
    selected_platforms = platform_names.map do |name|
      { name: name, id: map_watch_provider_to_id(name) }
    end

    current_user.update(selected_platforms: selected_platforms)
    if current_user.save
      redirect_to profile_path(current_user), notice: "Vos sélections de plateformes ont été enregistrées."
    else
      render :new
    end
    authorize current_user, :create?

    rescue NoMethodError
    flash[:alert] = 'Vous devez au moins selectionner une plateforme'
    redirect_to new_user_platform_path
    authorize current_user, :create?
  end

  private

  def user_platform_params
    params.require(:user).permit(platform_ids: [])
  end
end
