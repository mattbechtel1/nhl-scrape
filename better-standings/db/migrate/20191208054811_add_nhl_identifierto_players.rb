class AddNhlIdentifiertoPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :nhl_identifier, :integer

  end
end
