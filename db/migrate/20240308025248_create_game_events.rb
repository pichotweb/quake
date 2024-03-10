class CreateGameEvents < ActiveRecord::Migration[7.1]
  def up
    create_table :game_events do |t|
      t.integer :event_type
      t.string :time
      t.string :description
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end unless table_exists? :game_events
  end

  def down
    drop_table :game_events if table_exists? :game_events
  end
end
