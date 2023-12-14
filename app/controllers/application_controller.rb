class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  include Pundit

  after_action :verify_authorized, except: :index, unless: :skip_pundit?




  def configure_permitted_parameters

    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])


    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end

  private

  def not_found
    redirect_to '/404'
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
