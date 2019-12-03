class AddPointsPerGameToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :points_per_game, :float
    add_column :teams, :reg_wins_in_82, :float
  end
end
