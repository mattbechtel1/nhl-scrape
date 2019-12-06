class Conference < ApplicationRecord
    has_many :teams

    def team_position_by(playoff_code)
        self.teams.find{ |team| team.playoff_position.match(playoff_code) }
    end

    def team_position_like(playoff_code)
        self.teams.select{ |team| team.playoff_position.include?(playoff_code)}
    end

    def leading_team
        team_position_by(/ - /)
    end

    def wild_card_1
        team_position_by(/WC1/)
    end

    def wild_card_2
        team_position_by(/WC2/)
    end

    def first_place_teams
        team_position_like("1").reject{ |team| team == self.wild_card_1}
    end

    def second_place_teams
        team_position_like("2").reject{ |team| team == self.wild_card_2}
    end

    def third_place_teams
        team_position_like("3")
    end

    def second_place_in_lt_div
        self.second_place_teams.find{ |team| team.in_conf_leaders_div? }
    end

    def third_place_in_lt_div
        self.third_place_teams.find{ |team| team.in_conf_leaders_div? }
    end

    def first_place_other_div
        self.first_place_teams.find{ |team| !team.in_conf_leaders_div? }
    end

    def second_place_other_div
        self.second_place_teams.find{ |team| !team.in_conf_leaders_div? }
    end

    def third_place_other_div
        self.third_place_teams.find{ |team| !team.in_conf_leaders_div? }
    end
end