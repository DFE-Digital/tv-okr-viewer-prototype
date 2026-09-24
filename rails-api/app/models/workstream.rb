class Workstream < ApplicationRecord
  has_many :key_result_workstreams, dependent: :restrict_with_error
  has_many :key_results, through: :key_result_workstreams

  validates :title, presence: true, uniqueness: true
  validates :colour, presence: true
end
