class AddHomeTeamToColos < ActiveRecord::Migration
  def change
    add_column :colos, :Home_Team, :string
  end
end
