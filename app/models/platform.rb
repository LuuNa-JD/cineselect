class Platform < ApplicationRecord
  has_many :user_platform
  has_many :user, through: :user_platform
end
