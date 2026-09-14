class CreateWorkstreams < ActiveRecord::Migration[8.1]
  def change
    create_table :workstreams do |t|
      t.string :title, null: false
      t.string :colour, null: false, default: "#738096"
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :workstreams, :title, unique: true
  end
end
