class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :favorites
  has_many :seances
  has_many :user_platforms
  has_many :platforms, through: :user_platforms
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]

  def movie_in_favorites?(movie_id)
    favorites.exists?(tmdb_id: movie_id)
  end

  private

  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'default_profile.jpg'
          )
        ), filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
    end
  end

end
