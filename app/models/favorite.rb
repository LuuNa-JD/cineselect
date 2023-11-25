class Favorite < ApplicationRecord
  belongs_to :user

  validates :tmdb_id, uniqueness: { scope: :user_id }
end
