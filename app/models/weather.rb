class Weather < ActiveRecord::Base
  belongs_to :game

  def temp_num
    return 0.0 if temp.size == 0
    index = temp.index(".")
    index ? temp[0..index+1].to_f : temp[0..2].to_f
  end

  def dew_num
    return 0.0 if temp.size == 0
    index = dew.index(".")
    index ? dew[0..index+1].to_f : dew[0..1].to_f
  end

  def humid_num
    return 0.0 if humidity.size == 0
    humidity[0..1].to_f
  end

  def baro_num
    pressure.include?(".") ? (pressure[0...-3].to_i * 33.86375257787817).round(2) : 0.0
  end

  def pressure_num
    return 0.0 if temp.size == 0
    index = pressure.index(".")
    index ? pressure[0..index+2].to_f : pressure[0..1].to_f
  end

  def air_density
    unless baro_num == 0.0 || dew_num == 0.0 || temp_num == 0.0
      Create::AirDensity.new.run(baro_num, temp_num, dew_num)
    else
      0.0
    end
  end
  def self.true_data(temp_min, temp_max, dew_min, dew_max, humid_min, humid_max, baro_min, baro_max, name)
    table = Workbook
    if name == 'Astros'
      puts "Houston"
      table = Houston
    elsif name == 'Rays'
      puts "Tampa"
      table = Tampa
    elsif name == 'Rockies'
      puts "COL"
      table = Colo
    end
    query = table
    if temp_max != -1
      query = query.where('"TEMP" >= ? AND "TEMP" <= ?', temp_min, temp_max)
    end
    if dew_max != -1
     query = query.where('"DP" <= ? AND "DP" >= ?', dew_max, dew_min)
    end
    if humid_max != -1
     query = query.where('"HUMID" <= ? AND "HUMID" >= ?', humid_max, humid_min)
    end
    if baro_max != -1
     query = query.where('"BARo" <= ? AND "BARo" >= ?', (baro_max*100).round/100.0, (baro_min*100).round/100.0)
    end

    count= query.count(:R)
    te = query.average(:R)
    total_runs1_avg = (((te.to_f)* 100).round/100.0)
    te = query.average(:Total_Hits)
    total_runs2_avg = (((te.to_f)* 100).round/100.0)
    te = query.average(:Total_Walks)
    total_hits_avg = (((te.to_f)* 100).round/100.0)
    te = query.average(:home_runs)
    home_runs_avg = (((te.to_f)* 100).round/100.0)

    query = table
    if temp_max != -1
      query = query.where('"TEMP" >= ? AND "TEMP" <= ?', temp_min, temp_max)
    end
    if dew_max != -1
     query = query.where('"DP" <= ? AND "DP" >= ?', dew_max - 1, dew_min + 1)
    end
    if humid_max != -1
     query = query.where('"HUMID" <= ? AND "HUMID" >= ?', humid_max, humid_min)
    end
    if baro_max != -1
     query = query.where('"BARo" <= ? AND "BARo" >= ?', (baro_max*100).round/100.0, (baro_min*100).round/100.0)
    end
    te = query.average(:R)
    one = (((te.to_f)* 100).round/100.0)
    one_count = query.count(:R)

    query = table
    if name != ""
      query = query.where('"Home_Team" = ?', name)
    end
    if temp_max != -1
      query = query.where('"TEMP" >= ? AND "TEMP" <= ?', temp_min, temp_max)
    end
    if dew_max != -1
     query = query.where('"DP" <= ? AND "DP" >= ?', dew_max, dew_min)
    end
    if humid_max != -1
     query = query.where('"HUMID" <= ? AND "HUMID" >= ?', humid_max, humid_min)
    end
    if baro_max != -1
     query = query.where('"BARo" <= ? AND "BARo" >= ?', (baro_max*100).round/100.0, (baro_min*100).round/100.0)
    end
    te = query.average(:R)
    home_total_runs1_avg = (((te.to_f)* 100).round/100.0)
    te = query.average(:Total_Hits)
    home_total_runs2_avg = (((te.to_f)* 100).round/100.0)
    home_count= query.count(:R)

    query = table
    if name != ""
      query = query.where('"Home_Team" = ?', name)
    end
    if temp_max != -1
      query = query.where('"TEMP" >= ? AND "TEMP" <= ?', temp_min, temp_max)
    end
    if dew_max != -1
     query = query.where('"DP" <= ? AND "DP" >= ?', dew_max-1, dew_min+1)
    end
    if humid_max != -1
     query = query.where('"HUMID" <= ? AND "HUMID" >= ?', humid_max, humid_min)
    end
    if baro_max != -1
     query = query.where('"BARo" <= ? AND "BARo" >= ?', (baro_max*100).round/100.0, (baro_min*100).round/100.0)
    end
    te = query.average(:R)
    home_one = (((te.to_f)* 100).round/100.0)
    home_one_count = query.count(:R)
    return count, total_runs1_avg, total_runs2_avg, total_hits_avg, home_runs_avg, one, one_count, home_total_runs1_avg, home_total_runs2_avg, home_count, home_one, home_one_count
  end

  def self.wind_data(name, first_wind, second_wind, third_wind)
    if first_wind == "0"
      first_wind_amount = 0
      first_wind_direction = "Variable"
    else
      first_wind = first_wind.gsub("mph ", "")
      first_wind = first_wind.gsub(/[[:space:]]+/," ")
      index = first_wind.index(" ")
      first_wind_amount = index ? first_wind[0..index-1].to_f : 0
      first_wind_direction = index ? first_wind[index+1..first_wind.length] : "Variable"
    end

    if second_wind == "0"
      second_wind_amount = 0
      second_wind_direction = "Variable"
    else
      second_wind = second_wind.gsub("mph ", "")
      second_wind = second_wind.gsub(/[[:space:]]+/," ")
      index = second_wind.index(" ")
      second_wind_amount = index ? second_wind[0..index-1].to_f : 0
      second_wind_direction = index ? second_wind[index+1..second_wind.length] : "Variable"
    end

    if third_wind == "0"
      third_wind_amount = 0
      third_wind_direction = "Variable"
    else
      third_wind = third_wind.gsub("mph ", "")
      third_wind = third_wind.gsub(/[[:space:]]+/," ")
      index = third_wind.index(" ")
      third_wind_amount = index ? third_wind[0..index-1].to_f : 0
      third_wind_direction = index ? third_wind[index+1..third_wind.length] : "Variable"
    end

    table = Wind
    winds = []
    if name == 'Rockies'
      table = Colowind
    end

    query = table.where('"Home_Team" = ?', name)

    wind = []
    wind << "average runs in this stadium"

    te = query.average(:R)
    wind << (((te.to_f)* 100).round/100.0)

    te = query.average(:Total_Hits)
    wind <<(((te.to_f)* 100).round/100.0)

    wind << query.count(:R)

    te = query.average(:Total_Walks)
    wind << (((te.to_f)* 100).round/100.0)

    te = query.average(:home_runs)
    wind << (((te.to_f)* 100).round/100.0)

    wind << 0
    winds << wind


    query = query.where('"N" >= 0 AND "N" <= 5')

    wind = []
    wind << "average runs in this stadium with 0-5mph winds"

    te = query.average(:R)
    wind << (((te.to_f)* 100).round/100.0)

    te = query.average(:Total_Hits)
    wind <<(((te.to_f)* 100).round/100.0)

    wind << query.count(:R)

    te = query.average(:Total_Walks)
    wind << (((te.to_f)* 100).round/100.0)

    te = query.average(:home_runs)
    wind << (((te.to_f)* 100).round/100.0)

    wind << 0
    winds << wind

    if first_wind_amount > second_wind_amount
      temp = first_wind_amount
      first_wind_amount = second_wind_amount
      second_wind_amount = temp
    end

    if first_wind_amount > third_wind_amount
      temp = first_wind_amount
      first_wind_amount = third_wind_amount
      third_wind_amount = temp
    end

    if second_wind_amount > third_wind_amount
      temp = second_wind_amount
      second_wind_amount = third_wind_amount
      third_wind_amount = temp
    end

    if third_wind_amount > 5
      filter_min = 6
      filter_max = 13

      if first_wind_amount < 6
        if second_wind_amount < 6
          filter_value = third_wind_amount
        else
          filter_value = second_wind_amount
        end
      else
        filter_value = first_wind_amount
      end

      filter_value = filter_value.to_i

      if filter_value > 6
        filter_min = filter_value - 1
        filter_max = filter_value + 6
      end

      wind_directions = ["NNW", "North", "NNE", "NE", "ENE", "East", "ESE", "SE", "SSE", "South", "SSW", "SW", "WSW", "West", "WNW", "NW", "NNW", "N"]
      currect_directions = []
      real_directions = []
      teams = Hash[
        'Angels' => 'LAA',
        'Astros' => 'HOU',
        'Athletics' => 'OAK',
        'Blue Jays' => 'TOR',
        'Braves' => 'ATL',
        'Brewers' => 'MIL',
        'Cardinals' => 'STL',
        'Cubs' => 'CHC',
        'Diamondbacks' => 'ARI',
        'Dodgers' => 'LAD',
        'Giants' => 'SFG',
        'Indians' => 'CLE',
        'Mariners' => 'SEA',
        'Marlins' => 'MIA',
        'Mets' => 'NYM',
        'Nationals' => 'WSN',
        'Orioles' => 'BAL',
        'Padres' => 'SDP',
        'Phillies' => 'PHI',
        'Pirates' => 'PIT',
        'Rangers' => 'TEX',
        'Rays' => 'TBR',
        'Red Sox' => 'BOS',
        'Reds' => 'CIN',
        'Rockies' => 'COL',
        'Royals' => 'KCR',
        'Tigers' => 'DET',
        'Twins' => 'MIN',
        'White Sox' => 'CHW',
        'Yankees' => 'NYY'
      ]

      if wind_directions.include?(first_wind_direction)
        index = wind_directions.index(first_wind_direction)
        currect_directions.push(index-1)
        currect_directions.push(index)
        real_directions.push(index)
        currect_directions.push(index+1)
      end

      if wind_directions.include?(second_wind_direction)
        index = wind_directions.index(second_wind_direction)
        currect_directions.push(index-1)
        currect_directions.push(index)
        real_directions.push(index)
        currect_directions.push(index+1)
      end

      if wind_directions.include?(third_wind_direction)
        index = wind_directions.index(third_wind_direction)
        currect_directions.push(index-1)
        currect_directions.push(index)
        real_directions.push(index)
        currect_directions.push(index+1)
      end

      currect_directions = currect_directions.uniq

      query_limit = table.where('"Home_Team" = ?', name)
      .where('"N" >= ? AND "N" <= ?', filter_min, filter_max)

      query = query_limit

      wind = []
      wind << "average runs in this stadium with #{filter_min}-#{filter_max}mph winds"

      te = query.average(:R)
      wind << (((te.to_f)* 100).round/100.0)

      te = query.average(:Total_Hits)
      wind <<(((te.to_f)* 100).round/100.0)

      wind << query.count(:R)

      te = query.average(:Total_Walks)
      wind << (((te.to_f)* 100).round/100.0)

      te = query.average(:home_runs)
      wind << (((te.to_f)* 100).round/100.0)

      wind << 1
      winds << wind

      wind_directions.each_with_index do |direction, index|
        query = query_limit.where('"M" = ?', wind_directions[index])

        wind = []
        additional_wind = ''
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
    
    if directions.include?(wind_directions[index]) && parks.include?(teams[name])
      additional_wind =  re[teams[name]][wind_directions[index]]
    end
        wind << "average runs in this stadium with #{filter_min}-#{filter_max}mph, going #{wind_directions[index]} (#{additional_wind})"

        te = query.average(:R)
        wind << (((te.to_f)* 100).round/100.0)

        te = query.average(:Total_Hits)
        wind <<(((te.to_f)* 100).round/100.0)

        wind << query.count(:R)

        te = query.average(:Total_Walks)
        wind << (((te.to_f)* 100).round/100.0)

        te = query.average(:home_runs)
        wind << (((te.to_f)* 100).round/100.0)

        if real_directions.include?(index)
          wind << 1
        elsif currect_directions.include?(index)
          wind << 0
        else
          wind << 2
        end
        winds << wind
      end
    else
      winds[1][6] = 1
    end   
    return winds
  end

end
