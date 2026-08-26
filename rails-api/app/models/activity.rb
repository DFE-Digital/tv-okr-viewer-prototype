class Activity < ApplicationRecord
  belongs_to :key_result

  validates :workstream, :activity, :status, presence: true

  delegate :objective, to: :key_result
end
