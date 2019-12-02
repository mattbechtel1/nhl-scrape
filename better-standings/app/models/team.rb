class Team < ApplicationRecord
  belongs_to :conference

  def playoff_name_format
    "#{self.playoff_position}: #{self.name}"
  end

  def in_conf_leaders_div?
    self.division == self.conference.leading_team.division
  end

  def points_per_game
    self.standings_points.to_f / self.games_played
  end

  def reg_wins_in_82
    self.regulation_wins.to_f / self.games_played * 82
  end

  def better_teams
    # ppg = self.points_per_game
    Team.where('standings_points / games_played > ? OR (standings_points / games_played = ? AND regulation_wins / games_played = ?)', self.points_per_game, self.points_per_game, self.reg_wins_in_82)
    # Team.all.select {|team| team.points_per_game > self.points_per_game || (team.points_per_game == self.points_per_game && team.reg_wins_in_82 > self.reg_wins_in_82) }
  end

  def conference_teams
    Team.where('conference_id = ?', self.conference)
  end

  def division_teams
    Team.where('division = ?', self.division)
  end

  def better_conf_teams
    Team.where('conference_id = ? AND (standings_points * 1.0 / games_played > ? OR (standings_points * 1.0 / games_played = ? AND regulation_wins * 1.0 / games_played = ?))', self.conference_id, self.points_per_game, self.points_per_game, self.reg_wins_in_82)
  end

  def better_div_teams
    Team.where('division = ? AND (standings_points * 1.0 / games_played > ? OR (standings_points * 1.0 / games_played = ? AND regulation_wins * 1.0 / games_played = ?))', self.division, self.points_per_game, self.points_per_game, self.reg_wins_in_82)
  end

  # def games_behind(compared_team)
  #   (self.games_played - compared_team.games_played + compared_team.standings_points - self.standings_points).to_f / 2
  # end

  # def determine_comparison_team(better_conf_teams, better_div_teams)
  #   better_alt_div_teams = better_conf_teams - better_div_teams
  #   if better_alt_div_teams.count >= 5
  #     games_behind(better_div_teams[2]) >= games_behind(better_alt_div_teams[4]) ? better_div_teams[2] : better_alt_div_teams[4]
  #   else
  #     better_div_teams[2]
  #   end
  # end

  def playoff_position
    # better_conf_teams = self.better_teams.select { |team| team.conference == self.conference}
    # better_div_teams = self.better_teams.select { |team| team.division == self.division}
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