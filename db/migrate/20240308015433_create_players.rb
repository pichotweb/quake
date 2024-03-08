class CreatePlayers < ActiveRecord::Migration[7.1]
  def up
    create_table :players do |t|
      t.string :name
      t.string :team
      t.integer :kill_score, default: 0
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end unless table_exists? :players
  end

  def down
    drop_table :players if table_exists? :players
  end
end
