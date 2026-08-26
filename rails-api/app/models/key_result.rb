class KeyResult < ApplicationRecord
  belongs_to :objective
  has_many :activities, dependent: :destroy

  validates :title, presence: true
end
