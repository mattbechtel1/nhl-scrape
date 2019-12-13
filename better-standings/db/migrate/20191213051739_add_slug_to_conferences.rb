class AddSlugToConferences < ActiveRecord::Migration[6.0]
  def change
    add_column :conferences, :slug, :string
  end
end
