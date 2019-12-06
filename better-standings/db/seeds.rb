require 'json'
require 'rest-client'

Team.destroy_all
Conference.destroy_all
Game.destroy_all

STANDINGS = 'https://statsapi.web.nhl.com/api/v1/standings'

response_string_standings = RestClient.get(STANDINGS)
response_standings = JSON.parse(response_string_standings)

puts 'seeding teams'
tnum = 1
response_standings["records"].each do | division |
    team_conference = Conference.find_or_create_by(name: division["conference"]["name"])
    
    division["teamRecords"].each do | team |
        puts 31 - tnum
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
        tnum += 1
    end 
end


GAMES_PREFIX = 'https://statsapi.web.nhl.com/api/v1/game/201902'
GAMES_SUFFIX = '/feed/live'
GAME_NUMBERS = [*1..1271]
# GAME_NUMBERS = [*1..150]

def to_four_digit_string(num)
    num.to_s.rjust(4, '0')
end

def match_team(nhl_id)
    team = Team.find_by(nhl_identifier: nhl_id)
    team.id
end

    puts 'seeding games'
GAME_NUMBERS.each { |game_num| 
    game_num_str = to_four_digit_string(game_num)
    request_string = "#{GAMES_PREFIX}#{game_num_str}#{GAMES_SUFFIX}"
    response_string_game = RestClient.get(request_string)
    response_game = JSON.parse(response_string_game)
    
    puts 1271 - game_num

    if response_game["gamePk"]
        if response_game["liveData"]["decisions"]["winner"]
                #find the winning goalie
            winning_goalie = response_game["liveData"]["decisions"]["winner"]["id"]

                #get the teams
            if response_game["liveData"]["teams"]
                teams = response_game["liveData"]["teams"]
            else
                teams = response_game["liveData"]["boxscore"]["teams"]
            end
               
                #match him in the team hash
            winning_team_identifier = teams.find { |team_type, team| 
                team["goalies"].include?(winning_goalie) }[1]["team"]["id"]

                #get the loser
            losing_team_identifier = teams.find { |team_type, team| 
                !team["goalies"].include?(winning_goalie) }[1]["team"]["id"]

            if response_game["liveData"]["decisions"]["firstStar"]
                Game.create(
                    nhl_identifier: response_game["gamePk"],
                    away_team_id: match_team(response_game["gameData"]["teams"]["away"]["id"]),
                    home_team_id: match_team(response_game["gameData"]["teams"]["home"]["id"]),
                    first_star_player_id: response_game["liveData"]["decisions"]["firstStar"]["id"],
                    second_star_player_id: response_game["liveData"]["decisions"]["secondStar"]["id"],
                    third_star_player_id: response_game["liveData"]["decisions"]["thirdStar"]["id"],
                    gametime: response_game["gameData"]["datetime"]["dateTime"],
                    winning_team_id: match_team(winning_team_identifier),
                    losing_team_id: match_team(losing_team_identifier)
            )
            else
                Game.create(
                    nhl_identifier: response_game["gamePk"],
                    away_team_id: match_team(response_game["gameData"]["teams"]["away"]["id"]),
                    home_team_id: match_team(response_game["gameData"]["teams"]["home"]["id"]),
                    winning_team_id: match_team(winning_team_identifier),
                    losing_team_id: match_team(losing_team_identifier)
            )
            end
        else
            Game.create(
                nhl_identifier: response_game["gamePk"],
                away_team_id: match_team(response_game["gameData"]["teams"]["away"]["id"]),
                home_team_id: match_team(response_game["gameData"]["teams"]["home"]["id"])
            )
        end
    end
    }

#     puts 'setting teams with games'
# Game.where.not(winning_team_id: nil).each { |game|
#     puts 1271 - game.id
#     home_win = game.home_team_id == game.winning_team_id
#     GamesTeam.create(team_id: game.winning_team_id, game_id: game.id, win: true, home_game: home_win)
#     GamesTeam.create(team_id: game.losing_team_id, game_id: game.id, win: false, home_game: !home_win)
# }