namespace :job do

  task test: :environment do
    include NewShare
    url = "https://www.baseball-reference.com/players/split.fcgi?id=achteaj01&year=Career&t=p"
    doc = download_document(url)
    doc.css("#plato tbody .left , #plato .right").each do |elem|
      puts elem.text
    end

  end

  task daily: [:create_players, :update_batters, :update_pitchers, :update_hour_stadium_runs]

  task hourly: [:update_weather, :update_forecast, :update_games, :pitcher_box_score, :test_bullpen]

  task ten: [:create_matchups]

  task create_season: :environment do
    Season.create_seasons
  end
  
  task create_teams: :environment do
    Team.create_teams
  end

  task create_games: :environment do
    Season.all.each { |season| season.create_games }
  end

  task create_players: :environment do
    Season.where("year = 2017").each { |season| season.create_players }
  end

  task update_batters: :environment do
    Season.where("year = 2017").order("year DESC").each { |season| season.update_batters }
  end

  task update_pitchers: :environment do
    Season.where("year = 2017").map { |season| season.update_pitchers }
    Cleanup.prev_pitchers(GameDay.today)
    Cleanup.prev_pitchers(GameDay.tomorrow)
  end

  task create_matchups: :environment do
    [GameDay.yesterday, GameDay.today, GameDay.tomorrow].each { |game_day| game_day.create_matchups }
  end

  task update_games: :environment do
    GameDay.today.update_games
  end

  task update_weather: :environment do
    GameDay.yesterday.update_weather
    GameDay.today.update_weather
  end

  task update_forecast: :environment do
    [GameDay.today, GameDay.tomorrow].each { |game_day| game_day.update_forecast }
  end

  task pitcher_box_score: :environment do
    GameDay.yesterday.pitcher_box_score
  end

  task delete_games: :environment do
    GameDay.today.delete_games
  end

  task update_local_hour: :environment do
    Season.all.each { |season| season.game_days.each{ |game_day| game_day.update_local_hour } }
  end

  task update_hour_stadium_runs: :environment do
    Game.where(stadium: "").each do |game|
      game.update_hour_stadium_runs
    end
  end

  task fix_weather: :environment do
    GameDay.all.each do |game_day|
      game_day.update_weather
    end
  end

  task test_bullpen: :environment do
    Test::Bullpen.new.run
  end

  task fix_game_lancers: :environment do
    Game.all.each do |game|
      away_id = game.away_team_id
      home_id = game.home_team_id
      game.lancers.where.not("team_id = ? OR team_id = ?", away_id, home_id).destroy_all
    end
  end

  task add: :environment do
    filename = File.join Rails.root, "Workbook.csv"
    count = 0
    CSV.foreach(filename, headers:true) do |row|
      Workbook.create(Home_Team:row['Home_Team'], TEMP:row['TEMP'], DP:row['DP'], HUMID:row['HUMID'], BARo:row['BARo'], R:row['R'], Total_Hits:row['Total_Hits'], Total_Walks:row['Total_Walks'], home_runs:row['home_runs'])
      count = count + 1
    end
    puts count

    filename = File.join Rails.root, "colo.csv"
    count = 0
    CSV.foreach(filename, headers:true) do |row|
      Colo.create(Home_Team:row['Home_Team'], TEMP:row['temp'], DP:row['DP'], HUMID:row['HUMID'], BARo:row['Baro'], R:row['R'], Total_Hits:row['Total_Hits'], Total_Walks:row['Total_Walks'], home_runs:row['home_runs'])
      count = count + 1
    end
    puts count

    filename = File.join Rails.root, "houston.csv"
    count = 0
    CSV.foreach(filename, headers:true) do |row|
      Houston.create(Home_Team:row['Home_Team'], TEMP:row['TEMP'], DP:row['DP'], HUMID:row['HUMID'], BARo:row['BARo'], R:row['R'], Total_Hits:row['Total_Hits'], Total_Walks:row['Total_Walks'], home_runs:row['home_runs'])
      count = count + 1
    end
    puts count

    filename = File.join Rails.root, "tampa.csv"
    count = 0
    CSV.foreach(filename, headers:true) do |row|
      Tampa.create(Home_Team:row['Home_Team'], TEMP:row['TEMP'], DP:row['DP'], HUMID:row['HUMID'], BARo:row['BARo'], R:row['R'], Total_Hits:row['Total_Hits'], Total_Walks:row['Total_Walks'], home_runs:row['home_runs'])
      count = count + 1
    end
    puts count
  end

  task debug: :environment do
    forecasts = Weather.where(game_id:46502).where(station: "Forecast").order(:created_at)
    forecast_count = forecasts.count().to_i
    forecast_data = []
    forecast_element = []
    puts forecast_count
    if forecast_count%3 == 0 && forecast_count > 0
      forecasts.each_with_index do |forecast_one, index|
        forecast_element << forecast_one
        if index % 3 == 2
          puts index
          forecast_data << forecast_element
          forecast_element = []
        end
      end
      forecast_data.each do |forecast_element|
      end
    end
  end

  task checking: :environment do
    GameDay.find_or_create_by(season: Season.find_by_year('2017'), date: '2017-08-10').pitcher_box_score
  end

  task fix: :environment do
    weathers = Weather.where(humidity: "66%", pressure: "30.03 in", wind: "Calm Calm", temp:"82.4 °F")
    weathers.each do |weather|
      game_id = weather.game_id
      puts game_id
      Game.find_or_create_by(id:game_id).update_weather
    end
  end

end
