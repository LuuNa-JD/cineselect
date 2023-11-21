class Seance < ApplicationRecord
  belongs_to :user
  validates :seance_type, presence: true, inclusion: { in: ['Film', 'Série'] }
end
