class CreateWinds < ActiveRecord::Migration
  def change
    create_table :winds do |t|
      t.string :Home_Team
      t.float :TEMP
      t.float :DP
      t.float :HUMID
      t.float :BARo
      t.string :M
      t.float :N
      t.float :R
      t.float :Total_Hits
      t.float :Total_Walks
      t.float :home_runs

      t.timestamps
    end
  end
end
