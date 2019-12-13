class AddSlugToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :slug, :string
  end
end
