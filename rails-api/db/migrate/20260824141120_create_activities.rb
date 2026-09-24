class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :key_result, null: false, foreign_key: true
      t.string :workstream, null: false
      t.string :activity, null: false
      t.integer :start_sprint
      t.integer :end_sprint
      t.string :status, null: false, default: "Not started"
      t.string :delivery_link
      t.string :depends_on
      t.string :schedule_basis

      t.timestamps
    end
  end
end
