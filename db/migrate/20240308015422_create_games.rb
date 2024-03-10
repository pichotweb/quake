class CreateGames < ActiveRecord::Migration[7.1]
  def up
    create_table :games do |t|
      t.integer :kills_count
      t.integer :players_count
      t.json :params, default: {}

      t.timestamps
    end unless table_exists? :games
  end

  def down
    drop_table :games if table_exists? :games
  end
end
