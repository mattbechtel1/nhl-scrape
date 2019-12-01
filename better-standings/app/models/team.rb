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
    Team.all.select {|team| team.points_per_game > self.points_per_game || (team.points_per_game == self.points_per_game && team.reg_wins_in_82 > self.reg_wins_in_82) }
  end

  def conference_teams
    Team.where('conference_id = ?', self.conference)
  end

  def division_teams
    Team.where('division = ?', self.division)
  end

  def playoff_position
    better_conf_teams = self.better_teams.select { |team| team.conference == self.conference}
    better_div_teams = self.better_teams.select { |team| team.division == self.division}

    if better_conf_teams.count == 0
      "#{self.division}1 - #{self.conference.name[0]}1"
    elsif better_div_teams.count < 3
      "#{self.division}#{better_div_teams.count + 1}"
    elsif better_div_teams.count < 4 && better_conf_teams.count < 7
      "WC1"
    elsif better_conf_teams.count < 8 && better_div_teams.count < 5
      "WC2"
    else
      ""
    end
  end

end