class CreateJoinTableTeamsGames < ActiveRecord::Migration[6.0]
  def change
    create_join_table :teams, :games do |t|
      # t.index [:team_id, :game_id]
      # t.index [:game_id, :team_id]
    end
  end
end
