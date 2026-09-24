class CreateKeyResultWorkstreams < ActiveRecord::Migration[8.1]
  def change
    create_table :key_result_workstreams do |t|
      t.references :key_result, null: false, foreign_key: true
      t.references :workstream, null: false, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :key_result_workstreams,
              [:key_result_id, :workstream_id],
              unique: true,
              name: "index_kr_workstreams_on_kr_and_workstream"
  end
end
