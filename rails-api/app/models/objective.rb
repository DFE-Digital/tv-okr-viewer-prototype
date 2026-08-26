class Objective < ApplicationRecord
  has_many :key_results, dependent: :destroy

  validates :title, presence: true
end
