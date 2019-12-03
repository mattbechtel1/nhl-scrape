class Team < ApplicationRecord
  belongs_to :conference

  def playoff_name_format
    "#{self.playoff_position}: #{self.name}"
  end

  def in_conf_leaders_div?
    self.division == self.conference.leading_team.division
  end

  # def better_teams
  #   Team.where('points_per_game > ? OR (points_per_game = ? AND reg_wins_in_82 = ?)', self.points_per_game, self.points_per_game, self.reg_wins_in_82)
  # end

  def conference_teams
    Team.where('conference_id = ?', self.conference)
  end

  def division_teams
    Team.where('division = ?', self.division)
  end

  def better_conf_teams
    Team.where('id != ? AND conference_id = ? AND (points_per_game > ? OR (points_per_game = ? AND reg_wins_in_82 = ?))', self.id, self.conference_id, self.points_per_game, self.points_per_game, self.reg_wins_in_82)
  end

  def better_div_teams
    Team.where('id != ? AND division = ? AND (points_per_game > ? OR (points_per_game = ? AND reg_wins_in_82 = ?))', self.id, self.division, self.points_per_game, self.points_per_game, self.reg_wins_in_82)
  end

  # def games_behind(compared_team)
  #   (self.games_played - compared_team.games_played + compared_team.standings_points - self.standings_points).to_f / 2
  # end

  def playoff_position
    if self.better_conf_teams.count == 0
      puts "Now processing #{self.name} - #{self.id} - Best Team"
      "#{self.division}1 - #{self.conference.name[0]}1"
    elsif self.better_div_teams.count < 3
      puts "Now processing #{self.name} - #{self.id} - Elite Division Team"
      "#{self.division}#{better_div_teams.count + 1}"
    elsif self.better_div_teams.count < 4 && self.better_conf_teams.count < 7
      puts "Now processing #{self.name} - #{self.id} - WC1"
      "WC1"
    elsif self.better_conf_teams.count < 8 && self.better_div_teams.count < 5
      puts "Now processing #{self.name} - #{self.id} - WC2"
      "WC2"
    else
      puts "Now processing #{self.name} - A bad team"
      ""
    end
  end
end