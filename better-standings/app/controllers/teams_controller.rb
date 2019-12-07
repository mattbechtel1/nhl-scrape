class TeamsController < ApplicationController
  def show
    @team = Team.find(params[:id])
    @games = @team.games.order(:gametime)
  end
end
