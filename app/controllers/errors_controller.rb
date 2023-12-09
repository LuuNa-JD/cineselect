class ErrorsController < ApplicationController
  skip_after_action :verify_authorized, only: :not_found

  def not_found
    render status: 404
  end

  def internal_server_error
    render status: 500
  end
end
