require 'json'
require 'rest-client'

Team.destroy_all
Conference.destroy_all

def division_determination(nhl_identifier)
    if [1, 2, 3, 4, 5, 12, 15, 29].include?(nhl_identifier)
        "Metropolitan"
    elsif [6, 7, 8 ,9 ,10, 13, 14, 17].include?(nhl_identifier)
        "Atlantic"
    elsif [16, 18, 19, 21, 25, 30, 52].include?(nhl_identifier)
        "Central"
    elsif [20, 22, 23, 24, 26, 28, 53, 54].include?(nhl_identifier)
        "Pacific"
    else
        "Error"
    end
end

STANDINGS = 'https://statsapi.web.nhl.com/api/v1/standings/byConference'

response_string = RestClient.get(STANDINGS)
response_hash = JSON.parse(response_string)


response_hash["records"].each do | conference |
    team_conference = Conference.create(name: conference["conference"]["name"])
    
    conference["teamRecords"].each do | team |
        Team.create(
            name: team["team"]["name"],
            standings_points: team["points"],
            games_played: team["gamesPlayed"],
            regulation_wins: team["regulationWins"],
            division: division_determination(team["team"]["id"]),
            conference: team_conference,
            nhl_identifier: team["team"]["id"]
        )
    end 
end

