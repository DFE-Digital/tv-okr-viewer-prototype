class AddKeyResultWorkstreamToActivities < ActiveRecord::Migration[8.1]
  def change
    add_reference :activities,
                  :key_result_workstream,
                  null: true,
                  foreign_key: true
  end
end
