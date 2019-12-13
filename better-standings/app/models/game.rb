class Game < ApplicationRecord
    has_many :team_games
    has_many :teams, through: :team_games

    def home_team
        Team.find(self.home_team_id)
    end

    def away_team
        Team.find(self.away_team_id)
    end

    def losing_team
        Team.find(self.losing_team_id)
    end

    def winning_team
        Team.find(self.winning_team_id)
    end
end
