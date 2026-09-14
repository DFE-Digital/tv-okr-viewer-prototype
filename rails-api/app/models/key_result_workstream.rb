class KeyResultWorkstream < ApplicationRecord
  belongs_to :key_result
  belongs_to :workstream
  has_many :activities, dependent: :destroy

  validates :workstream_id, uniqueness: { scope: :key_result_id }
end
