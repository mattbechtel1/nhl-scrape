class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :nhl_identifier
      t.integer :away_team_id
      t.integer :home_team_id
      t.integer :first_star_player_id
      t.integer :second_star_player_id
      t.integer :third_star_player_id

      t.timestamps
    end
  end
end
