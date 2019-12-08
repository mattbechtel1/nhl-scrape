class TeamGame < ApplicationRecord
  belongs_to :game
  belongs_to :team
end
