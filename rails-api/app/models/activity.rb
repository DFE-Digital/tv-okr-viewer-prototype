class Activity < ApplicationRecord
  belongs_to :key_result
  belongs_to :key_result_workstream

  validates :activity, :status, presence: true

  delegate :objective, to: :key_result
  delegate :workstream, to: :key_result_workstream
end