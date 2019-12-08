class Player < ApplicationRecord
  belongs_to :team

  def third_star_games
    self.team.games.where('third_star_player_id = ?', self.id).count
  end

  def second_star_games
    self.team.games.where('second_star_player_id = ?', self.id).count
  end

  def first_star_games
    self.team.games.where('first_star_player_id = ?', self.id).count
  end

  def star_score
    third_star_games + (second_star_games * 2) + (first_star_games * 3)
  end

end
