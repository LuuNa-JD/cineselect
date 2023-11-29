module ApplicationHelper
  def movie_in_favorites?(movie_id)
    user_signed_in? && current_user.favorites.exists?(tmdb_id: movie_id)
  end
end
