class CreateKills < ActiveRecord::Migration[7.1]
  def up
    create_table :kills do |t|
      t.integer :death_type
      t.references :killer, null: true, foreign_key: { to_table: :players }
      t.references :victim, null: false, foreign_key: { to_table: :players }
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end unless table_exists? :kills
  end

  def down
    drop_table :kills if table_exists? :kills
  end
end
