class AddHomeTeamToHoustons < ActiveRecord::Migration
  def change
    add_column :houstons, :Home_Team, :string
  end
end
