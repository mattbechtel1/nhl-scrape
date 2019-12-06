class AddDecisionsToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :winning_team_id, :integer
    add_column :games, :losing_team_id, :integer
  end
end
