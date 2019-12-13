class ConferencesController < ApplicationController
    before_action :get_conference, only: :show

    def index
        @conferences = Conference.all
    end
    
    def show
        @teams = @conference.teams.sort_by { | team | [-team.points_per_game, -team.reg_wins_in_82] }
        @alt_conference = Conference.where('id != ?', @conference.id)[0]
    end

    private

    def get_conference
        @conference = Conference.find_by(slug: params[:slug])
    end

    # def strong_params
    #     params.permit(:name, :id)
    # end
end
  