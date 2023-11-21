class SeancesController < ApplicationController
  def new
    @seance = Seance.new
    authorize @seance
  end
end
