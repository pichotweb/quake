class CreatePlayers < ActiveRecord::Migration[7.1]
  def up
    create_table :players do |t|
      t.string :name
      t.integer :session_id
      t.string :team
      t.integer :score, default: 0
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end unless table_exists? :players

    if table_exists?(:players) && column_exists?(:players, :session_id) && column_exists?(:players, :game_id)
      add_index :players, [:session_id, :game_id], unique: true
    end
  end

  def down
    drop_table :players if table_exists? :players
  end
end
