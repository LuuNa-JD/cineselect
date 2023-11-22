class SeriesPolicy < ApplicationPolicy


  def show?
    true
  end

  def show_streaming_platforms?
    true
  end
end
