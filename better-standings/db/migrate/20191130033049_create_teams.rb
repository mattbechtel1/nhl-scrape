class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :division
      t.integer :standings_points
      t.integer :games_played
      t.integer :regulation_wins
      t.references :conference, null: false, foreign_key: true

      t.timestamps
    end
  end
end
