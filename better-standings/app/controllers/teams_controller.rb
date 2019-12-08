class TeamsController < ApplicationController
  def show
    @team = Team.find(params[:id])
    @games = @team.games.order(:gametime)
    @players = @team.players.sort_by { |player| -player.star_score }
  end
end
