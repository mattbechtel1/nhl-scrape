class TeamsController < ApplicationController
  def show
    @team = Team.find_by(slug: params[:slug])
    @games = @team.games.order(:gametime)
    @players = @team.players.sort_by { |player| -player.star_score }
  end
end
