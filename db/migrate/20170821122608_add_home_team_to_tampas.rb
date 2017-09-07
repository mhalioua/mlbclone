class AddHomeTeamToTampas < ActiveRecord::Migration
  def change
    add_column :tampas, :Home_Team, :string
  end
end
