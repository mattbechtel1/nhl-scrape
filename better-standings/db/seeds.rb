require 'json'
require 'rest-client'

Team.destroy_all
Conference.destroy_all

STANDINGS = 'https://statsapi.web.nhl.com/api/v1/standings'

response_string = RestClient.get(STANDINGS)
response_hash = JSON.parse(response_string)


response_hash["records"].each do | division |
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

