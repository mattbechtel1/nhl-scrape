class Team < ApplicationRecord
  belongs_to :conference


  def points_per_game
    self.points.float / self.games_played
  end

end
