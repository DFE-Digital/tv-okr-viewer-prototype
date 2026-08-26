class CreateKeyResults < ActiveRecord::Migration[8.1]
  def change
    create_table :key_results do |t|
      t.references :objective, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
