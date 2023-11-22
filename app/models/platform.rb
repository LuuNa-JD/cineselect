class Platform < ApplicationRecord
  has_many :user_platforms
  has_many :users, through: :user_platforms
end
