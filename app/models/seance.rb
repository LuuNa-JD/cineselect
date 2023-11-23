class Seance < ApplicationRecord
  belongs_to :user
  validates :seance_type, presence: true, inclusion: { in: ['Film', 'Série'] }
  attr_accessor :search_type
end
