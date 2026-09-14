class KeyResult < ApplicationRecord
  belongs_to :objective
  has_many :key_result_workstreams, dependent: :destroy
  has_many :workstreams, through: :key_result_workstreams
  has_many :activities, dependent: :destroy

  validates :title, presence: true
end