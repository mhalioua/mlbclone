class CreateTampas < ActiveRecord::Migration
  def change
    create_table :tampas do |t|
      t.float :TEMP
      t.float :DP
      t.float :HUMID
      t.float :BARo
      t.float :R
      t.float :Total_Hits
      t.float :Total_Walks
      t.float :home_runs

      t.timestamps
    end
  end
end
