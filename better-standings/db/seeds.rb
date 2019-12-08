require 'json'
require 'rest-client'

Team.destroy_all
Conference.destroy_all
Game.destroy_all

STANDINGS = 'https://statsapi.web.nhl.com/api/v1/standings'

response_string_standings = RestClient.get(STANDINGS)
response_standings = JSON.parse(response_string_standings)

response_standings["records"].each do | division |
    team_conference = Conference.find_or_create_by(name: division["conference"]["name"])
    
    division["teamRecords"].each do | team |
        Team.create(
            name: team["team"]["name"],
            standings_points: team["points"],
            games_played: team["gamesPlayed"],
            regulation_wins: team["regulationWins"],
            division: division["division"]["abbreviation"],
            conference: team_conference,
            nhl_identifier: team["team"]["id"],
            points_per_game: team["points"].to_f / team["gamesPlayed"],
            reg_wins_in_82: team["regulationWins"].to_f / team["gamesPlayed"] * 82
        )
    end 
end


GAMES_PREFIX = 'https://statsapi.web.nhl.com/api/v1/game/201902'
GAMES_SUFFIX = '/feed/live'
GAME_NUMBERS = [*1..1271]

def to_four_digit_string(num)
    num.to_s.rjust(4, '0')
end

def match_team(nhl_id)
    team = Team.find_by(nhl_identifier: nhl_id)
    team.id
end

GAME_NUMBERS.each { |game_num| 
    game_num_str = to_four_digit_string(game_num)
    request_string = "#{GAMES_PREFIX}#{game_num_str}#{GAMES_SUFFIX}"
    response_string_game = RestClient.get(request_string)
    response_game = JSON.parse(response_string_game)
    puts game_num
    if response_game["gamePk"]
        if response_game["liveData"]["decisions"]["firstStar"]
            Game.create(
                nhl_identifier: response_game["gamePk"],
                away_team_id: match_team(response_game["gameData"]["teams"]["away"]["id"]),
                home_team_id: match_team(response_game["gameData"]["teams"]["home"]["id"]),
                first_star_player_id: Player.find_or_create_by(
                    nhl_identifier: response_game["liveData"]["decisions"]["firstStar"]["id"],
                    name: response_game["liveData"]["decisions"]["firstStar"]["fullName"]), 
                second_star_player_id: Player.find_or_create_by(
                    nhl_identifier: response_game["liveData"]["decisions"]["secondStar"]["id"],
                    name: response_game["liveData"]["decisions"]["secondStar"]["fullName"]),
                third_star_player_id: Player.find_or_create_by(
                    nhl_identifier: response_game["liveData"]["decisions"]["thirdStar"]["id"],
                    name: response_game["liveData"]["decisions"]["thirdStar"]["fullName"])
        )
        else
            Game.create(
                nhl_identifier: response_game["gamePk"],
                away_team_id: match_team(response_game["gameData"]["teams"]["away"]["id"]),
                home_team_id: match_team(response_game["gameData"]["teams"]["home"]["id"])
        )
        end
    end
    }
