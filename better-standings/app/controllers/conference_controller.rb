class ConferenceController < ApplicationController
    def show
        @conference = Conference.all.find(strong_params)
    end


    private

    def strong_params
        params.require(:conference).permit(:name)
    end
end
  