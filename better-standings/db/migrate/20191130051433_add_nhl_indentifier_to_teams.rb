class AddNhlIndentifierToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :nhl_identifier, :integer
  end
end
