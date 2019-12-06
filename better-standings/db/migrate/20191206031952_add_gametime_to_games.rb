class AddGametimeToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :gametime, :datetime
  end
end
