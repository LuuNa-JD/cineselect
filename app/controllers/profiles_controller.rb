class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user, policy_class: ProfilePolicy
  end
end
