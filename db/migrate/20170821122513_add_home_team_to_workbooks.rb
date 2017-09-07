class AddHomeTeamToWorkbooks < ActiveRecord::Migration
  def change
    add_column :workbooks, :Home_Team, :string
  end
end
