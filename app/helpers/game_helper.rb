module GameHelper

  def add_innings(ip_array)
    sum = 0
    decimal = 0
    ip_array.each do |i|
      decimal += i.modulo(1)
      sum += i.to_i
    end
    thirds = (decimal*10).to_i
    sum += thirds/3
    return sum += (thirds%3).to_f/10
  end

  def batter_class(predicted)
    if predicted
      "predicted batter"
    else
      "batter"
    end
  end
  
  def weather_time(game_time, weather_hour)
    return if game_time.length == 0
  	weather_hour -= 1

  	colon_index = game_time.index(":")
  	game_hour = game_time[0...colon_index].to_i
  	game_minutes = game_time[colon_index+1..colon_index+2]
  	game_period = game_time[-2..-1]

  	weather_hour = game_hour + weather_hour
  	# Check if period needs to be changed
  	if game_hour != 12 && weather_hour >= 12
  	  if weather_hour > 12
  	  	weather_hour -= 12
  	  end
  	  if game_period == "PM"
  	  	game_period = "AM"
  	  else
  	  	game_period = "PM"
  	  end
  	end

  	weather_time = weather_hour.to_s + ":" + game_minutes + " " + game_period

  	return weather_time
  end


  def batter_stats(batter, left)
    stat_array = Array.new
    handed = handedness(left)
    stats = batter.stats
    stat_array << stats.find_by(handedness: handed)
    stat_array << stats.find_by(handedness: "")
    player = batter.player
    season = Season.find_by_year(batter.season.year-1)
    while season
      batter = player.create_batter(season)
      stat_array << batter.stats.where(handedness: handed).first
      season = Season.find_by_year(season.year-1)
    end
    return stat_array
  end

  def handedness(left)
    if left
      "L"
    else
      "R"
    end
  end


  def lefty_righty(index)

    if index == 0
      return num_batters_with_handedness(@away_starting_lancer.first, @home_batters)
    else
      return num_batters_with_handedness(@home_starting_lancer.first, @away_batters)
    end

  end

  def bullpen_day_name(num)

    num += 1
    day = Date.parse("#{@game_day.year}-#{@game_day.month}-#{@game_day.day}").wday
    return Date::DAYNAMES[day-num]

  end


  def handedness_header(left)

    if left
      "LHP"
    else
      "RHP"
    end

  end

  def d2_calc(park, direction)
    re = Hash[
      'ARI' => Hash[
        'North' => '',
        'NNE' => '',
        'NE' => '',
        'ENE' => '',
        'East' => '',
        'ESE' => '',
        'SE' => '',
        'SSE' => '',
        'South' => '',
        'SSW' => '',
        'SW' => '',
        'WSW' => '',
        'West' => '',
        'WNW' => '',
        'NW' => '',
        'NNW' => ''
      ],
      'ATL' => Hash[
        'North' => 'LO',
        'NNE' => 'LO',
        'NE' => 'CO/ro',
        'ENE' => 'RO',
        'East' => 'RO/lr',
        'ESE' => 'LR/ro',
        'SE' => 'LR',
        'SSE' => 'LI/LR',
        'South' => 'LI',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI/RL',
        'WNW' => 'RL/ri',
        'NW' => 'RL/lo',
        'NNW' => 'LO/rl'
      ],
      'BAL' => Hash[
        'North' => 'LO',
        'NNE' => 'LO',
        'NE' => 'CO/ro',
        'ENE' => 'RO',
        'East' => 'RO/lr',
        'ESE' => 'LR/ro',
        'SE' => 'LR',
        'SSE' => 'LI/LR',
        'South' => 'LI',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI/RL',
        'WNW' => 'RL/ri',
        'NW' => 'RL/lo',
        'NNW' => 'LO/rl'
      ],
      'BOS' => Hash[
        'North' => 'LO',
        'NNE' => 'LO',
        'NE' => 'CO/ro',
        'ENE' => 'RO',
        'East' => 'RO/lr',
        'ESE' => 'LR/RO',
        'SE' => 'LR/li',
        'SSE' => 'LI/LR',
        'South' => 'LI',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI/rl',
        'WNW' => 'RL/ri',
        'NW' => 'RL/lo',
        'NNW' => 'LO/RL'
      ],
      'CHC' => Hash[
        'North' => 'LO',
        'NNE' => 'LO',
        'NE' => 'CO/ro',
        'ENE' => 'RO',
        'East' => 'RO/lr',
        'ESE' => 'LR/RO',
        'SE' => 'LR',
        'SSE' => 'LI/LR',
        'South' => 'LI',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI/rl',
        'WNW' => 'RL/ri',
        'NW' => 'RL',
        'NNW' => 'RL/LO'
      ],
      'CHW' => Hash[
        'North' => 'RI/rl',
        'NNE' => 'RL/RI',
        'NE' => 'RL/lo',
        'ENE' => 'LO/rl',
        'East' => 'LO',
        'ESE' => 'LO',
        'SE' => 'CO',
        'SSE' => 'RO',
        'South' => 'RO/lr',
        'SSW' => 'RO/lr',
        'SW' => 'LR',
        'WSW' => 'LI/LR',
        'West' => 'LI',
        'WNW' => 'LI',
        'NW' => 'CI',
        'NNW' => 'RI'
      ],
      'CIN' => Hash[
        'North' => 'RI/rl',
        'NNE' => 'RL/RI',
        'NE' => 'RL/lo',
        'ENE' => 'LO/rl',
        'East' => 'LO',
        'ESE' => 'LO',
        'SE' => 'CO',
        'SSE' => 'RO',
        'South' => 'RO/lr',
        'SSW' => 'RO/lr',
        'SW' => 'LR',
        'WSW' => 'LI/LR',
        'West' => 'LI',
        'WNW' => 'LI',
        'NW' => 'CI',
        'NNW' => 'RI'
      ],
      'CLE' => Hash[
        'North' => 'CO',
        'NNE' => 'RO',
        'NE' => 'RO/lr',
        'ENE' => 'RO/lr',
        'East' => 'LR/li',
        'ESE' => 'LR',
        'SE' => 'LR/LI',
        'SSE' => 'LI',
        'South' => 'CI',
        'SSW' => 'RI',
        'SW' => 'RL/RI',
        'WSW' => 'RL',
        'West' => 'RL/lo',
        'WNW' => 'RL/LO',
        'NW' => 'LO/rl',
        'NNW' => 'LO'
      ],
      'COL' => Hash[
        'North' => 'CO',
        'NNE' => 'RO',
        'NE' => 'RO',
        'ENE' => 'RO/lr',
        'East' => 'LR',
        'ESE' => 'LR/LI',
        'SE' => 'LI',
        'SSE' => 'LI',
        'South' => 'CI',
        'SSW' => 'RI',
        'SW' => 'RI',
        'WSW' => 'RI/RL',
        'West' => 'RL',
        'WNW' => 'RL/LO',
        'NW' => 'LO',
        'NNW' => 'LO'
      ],
      'DET' => Hash[
        'North' => 'RI',
        'NNE' => 'RI/rl',
        'NE' => 'RL/RI',
        'ENE' => 'RL',
        'East' => 'RL/LO',
        'ESE' => 'LO/rl',
        'SE' => 'LO',
        'SSE' => 'CO',
        'South' => 'RO',
        'SSW' => 'RO',
        'SW' => 'RO/LR',
        'WSW' => 'LR/ro',
        'West' => 'LR/LI',
        'WNW' => 'LI/lr',
        'NW' => 'LI',
        'NNW' => 'RI'
      ],
      'HOU' => Hash[
        'North' => '',
        'NNE' => '',
        'NE' => '',
        'ENE' => '',
        'East' => '',
        'ESE' => '',
        'SE' => '',
        'SSE' => '',
        'South' => '',
        'SSW' => '',
        'SW' => '',
        'WSW' => '',
        'West' => '',
        'WNW' => '',
        'NW' => '',
        'NNW' => ''
      ],
      'KCR' => Hash[
        'North' => 'LO/rl',
        'NNE' => 'LO',
        'NE' => 'CO',
        'ENE' => 'RO',
        'East' => 'RO',
        'ESE' => 'RO/LR',
        'SE' => 'LR',
        'SSE' => 'LR/LI',
        'South' => 'LI/lr',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI',
        'WNW' => 'RI/RL',
        'NW' => 'RL',
        'NNW' => 'RL/LO'
      ],
      'LAA' => Hash[
        'North' => 'LO/rl',
        'NNE' => 'LO',
        'NE' => 'CO',
        'ENE' => 'RO',
        'East' => 'RO',
        'ESE' => 'RO/LR',
        'SE' => 'LR',
        'SSE' => 'LR/LI',
        'South' => 'LI/lr',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI',
        'WNW' => 'RI/RL',
        'NW' => 'RL',
        'NNW' => 'RL/LO'
      ],
      'LAD' => Hash[
        'North' => 'LO',
        'NNE' => 'LO',
        'NE' => 'RO',
        'ENE' => 'RO',
        'East' => 'RO/LR',
        'ESE' => 'LR/ro',
        'SE' => 'LR/li',
        'SSE' => 'LR/LI',
        'South' => 'LI',
        'SSW' => 'LI/CI',
        'SW' => 'CI',
        'WSW' => 'RI',
        'West' => 'RI/RL',
        'WNW' => 'RL',
        'NW' => 'RL/lo',
        'NNW' => 'LO/rl'
      ],
      'MIA' => Hash[
        'North' => 'RI',
        'NNE' => 'RL/RI',
        'NE' => 'RL',
        'ENE' => 'LO/rl',
        'East' => 'LO',
        'ESE' => 'LO',
        'SE' => 'CO',
        'SSE' => 'RO',
        'South' => 'RO',
        'SSW' => 'RO/lr',
        'SW' => 'LR',
        'WSW' => 'LI/LR',
        'West' => 'LI',
        'WNW' => 'LI',
        'NW' => 'CI',
        'NNW' => 'RI'
      ],
      'MIL' => Hash[
        'North' => 'RI/rl',
        'NNE' => 'RL/RI',
        'NE' => 'RL/lo',
        'ENE' => 'LO/rl',
        'East' => 'LO',
        'ESE' => 'LO',
        'SE' => 'CO',
        'SSE' => 'RO',
        'South' => 'RO/lr',
        'SSW' => 'RO/lr',
        'SW' => 'LR',
        'WSW' => 'LI/LR',
        'West' => 'LI',
        'WNW' => 'LI',
        'NW' => 'CI',
        'NNW' => 'RI'
      ],
      'MIN' => Hash[
        'North' => 'RL',
        'NNE' => 'RL/lo',
        'NE' => 'LO',
        'ENE' => 'LO',
        'East' => 'CO',
        'ESE' => 'RO',
        'SE' => 'RO',
        'SSE' => 'LR/RO',
        'South' => 'LR',
        'SSW' => 'LR/LI',
        'SW' => 'LI',
        'WSW' => 'LI',
        'West' => 'CI',
        'WNW' => 'RI',
        'NW' => 'RI',
        'NNW' => 'RL/RI'
      ],
      'NYM' => Hash[
        'North' => 'LO/CO',
        'NNE' => 'RO',
        'NE' => 'RO/lr',
        'ENE' => 'RO/LR',
        'East' => 'LR/RO',
        'ESE' => 'LR',
        'SE' => 'LI/LR',
        'SSE' => 'LI',
        'South' => 'CI/LI',
        'SSW' => 'RI',
        'SW' => 'RI/rl',
        'WSW' => 'RI/RL',
        'West' => 'RL/ri',
        'WNW' => 'RL',
        'NW' => 'LO/rl',
        'NNW' => 'LO'
      ],
      'NYY' => Hash[
        'North' => 'RL/lo',
        'NNE' => 'RL/LO',
        'NE' => 'LO',
        'ENE' => 'CO',
        'East' => 'RO',
        'ESE' => 'RO',
        'SE' => 'RO/lr',
        'SSE' => 'LR/ro',
        'South' => 'LI/LR',
        'SSW' => 'LI/lr',
        'SW' => 'LI',
        'WSW' => 'CI',
        'West' => 'RI',
        'WNW' => 'RI',
        'NW' => 'RI/RL',
        'NNW' => 'RL/ri'
      ],
      'OAK' => Hash[
        'North' => 'LO/rl',
        'NNE' => 'LO',
        'NE' => 'LO/co',
        'ENE' => 'RO/co',
        'East' => 'RO',
        'ESE' => 'RO/LR',
        'SE' => 'LR',
        'SSE' => 'LR/LI',
        'South' => 'LI/lr',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI/CI',
        'West' => 'RI',
        'WNW' => 'RI/RL',
        'NW' => 'RL/RI',
        'NNW' => 'RL/LO'
      ],
      'PHI' => Hash[
        'North' => 'CO/lo',
        'NNE' => 'CO',
        'NE' => 'RO',
        'ENE' => 'RO/LR',
        'East' => 'LR/ro',
        'ESE' => 'LR',
        'SE' => 'LI/lr',
        'SSE' => 'LI',
        'South' => 'CI',
        'SSW' => 'RI',
        'SW' => 'RI',
        'WSW' => 'RI/RL',
        'West' => 'RL/ri',
        'WNW' => 'RL/lo',
        'NW' => 'LO/rl',
        'NNW' => 'LO'
      ],
      'PIT' => Hash[
        'North' => 'RI/rl',
        'NNE' => 'RL/RI',
        'NE' => 'RL/lo',
        'ENE' => 'LO/rl',
        'East' => 'LO',
        'ESE' => 'LO',
        'SE' => 'CO',
        'SSE' => 'RO',
        'South' => 'RO/lr',
        'SSW' => 'RO/lr',
        'SW' => 'LR',
        'WSW' => 'LI/LR',
        'West' => 'LI',
        'WNW' => 'LI',
        'NW' => 'CI',
        'NNW' => 'RI'
      ],
      'SDP' => Hash[
        'North' => 'CO',
        'NNE' => 'RO',
        'NE' => 'RO/lr',
        'ENE' => 'RO/LR',
        'East' => 'LR/li',
        'ESE' => 'LR/LI',
        'SE' => 'LI',
        'SSE' => 'LI',
        'South' => 'CI',
        'SSW' => 'RI',
        'SW' => 'RI/rl',
        'WSW' => 'RI/RL',
        'West' => 'RL/lo',
        'WNW' => 'RL/LO',
        'NW' => 'LO/rl',
        'NNW' => 'LO'
      ],
      'SFG' => Hash[
        'North' => 'CO',
        'NNE' => 'RO',
        'NE' => 'RO/lr',
        'ENE' => 'RO/LR',
        'East' => 'LR/li',
        'ESE' => 'LR/LI',
        'SE' => 'LI',
        'SSE' => 'LI',
        'South' => 'CI',
        'SSW' => 'RI',
        'SW' => 'RI/rl',
        'WSW' => 'RI/RL',
        'West' => 'RL/lo',
        'WNW' => 'RL/LO',
        'NW' => 'LO/rl',
        'NNW' => 'LO'
      ],
      'SEA' => Hash[
        'North' => 'RL',
        'NNE' => 'RL/lo',
        'NE' => 'LO',
        'ENE' => 'LO',
        'East' => 'CO',
        'ESE' => 'RO',
        'SE' => 'RO',
        'SSE' => 'RO/LR',
        'South' => 'LR',
        'SSW' => 'LI/LR',
        'SW' => 'LI',
        'WSW' => 'LI',
        'West' => 'CI',
        'WNW' => 'RI',
        'NW' => 'RI',
        'NNW' => 'RI/RL'
      ],
      'STL' => Hash[
        'North' => 'LO/rl',
        'NNE' => 'LO',
        'NE' => 'LO/co',
        'ENE' => 'RO/co',
        'East' => 'RO',
        'ESE' => 'RO/LR',
        'SE' => 'LR',
        'SSE' => 'LR/LI',
        'South' => 'LI/lr',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI/CI',
        'West' => 'RI',
        'WNW' => 'RI/RL',
        'NW' => 'RL/RI',
        'NNW' => 'RL/LO'
      ],
      'TEX' => Hash[
        'North' => 'LO/rl',
        'NNE' => 'LO',
        'NE' => 'LO/co',
        'ENE' => 'RO/co',
        'East' => 'RO',
        'ESE' => 'RO/LR',
        'SE' => 'LR',
        'SSE' => 'LR/LI',
        'South' => 'LI/lr',
        'SSW' => 'LI',
        'SW' => 'CI',
        'WSW' => 'RI/CI',
        'West' => 'RI',
        'WNW' => 'RI/RL',
        'NW' => 'RL/RI',
        'NNW' => 'RL/LO'
      ],
      'TOR' => Hash[
        'North' => 'CO',
        'NNE' => 'RO',
        'NE' => 'RO',
        'ENE' => 'RL/lr',
        'East' => 'LR',
        'ESE' => 'LR/LI',
        'SE' => 'LI',
        'SSE' => 'LI',
        'South' => 'CI',
        'SSW' => 'RI',
        'SW' => 'RI',
        'WSW' => 'RI/RL',
        'West' => 'RL',
        'WNW' => 'RL/LO',
        'NW' => 'LO',
        'NNW' => 'LO'
      ],
      'WSN' => Hash[
        'North' => 'LO',
        'NNE' => 'LO/co',
        'NE' => 'CO/ro',
        'ENE' => 'RO',
        'East' => 'RO/LR',
        'ESE' => 'LR/ro',
        'SE' => 'LR',
        'SSE' => 'LI/LR',
        'South' => 'LI',
        'SSW' => 'LI/CO',
        'SW' => 'RI',
        'WSW' => 'RI',
        'West' => 'RI/RL',
        'WNW' => 'RL/ri',
        'NW' => 'RL/lo',
        'NNW' => 'LO/rl'
      ]
    ]
    directions = [ 'North', 'NNE', 'NE', 'ENE', 'East', 'ESE', 'SE', 'SSE', 'South', 'SSW', 'SW', 'WSW', 'West', 'WNW', 'NW', 'NNW']
    parks = ['ARI', 'ATL', 'BAL', 'BOS', 'CHC', 'CHW', 'CIN', 'CLE', 'COL', 'DET', 'HOU', 'KCR', 'LAA', 'LAD', 'MIA', 'MIL', 'MIN', 'NYM', 'NYY', 'OAK', 'PHI', 'PIT', 'SDP', 'SFG', 'SEA', 'STL', 'TEX', 'TOR', 'WSN']
    
    if directions.include?(direction) && parks.include?(park)
      return re[park][direction]
    else
      return ''
    end
  end


end
