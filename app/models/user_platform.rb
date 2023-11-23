class UserPlatform < ApplicationRecord
  belongs_to :user
  belongs_to :platform
  validates :platform_id, uniqueness: { scope: :user_id }
end
