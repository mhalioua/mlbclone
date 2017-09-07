module Update
  class Forecasts

    include NewShare

    def update(game)
      update_forecast(game)
    end

    private

      def update_forecast(game)

        game_day = game.game_day
    	  game_time = game.time
    	  unless game_time.include?(":")
    	    return
    	  end
        day = game_day.day.to_i
    	  game_hour = game_time[0...game_time.index(":")].to_i
    	  period = game_time[-2..-1]
    	  game_hour = convert_to_military_hour(game_hour, period)
        home_team = game.home_team

        key = [
          "fa0e4cf7f1a485a7",
          "7328331580f6e696",
          "551adab95cb2e4ac",
          "7cf57570554e8ca5",
          "b2a9f51442f8d09e",
          "f4d52db27009e864",
          "cf42ce52549e12ce",
          "2be7128030cafcef",
          "47e7b6828a6ae356",
          "afa9d178638ed8ae"
        ]
        
		    url = "http://api.wunderground.com/api/key/hourly10day/q/#{home_team.zipcode}.json"
        if home_team.id == 4
          url = "http://api.wunderground.com/api/key/hourly10day/q/M5V1J1.json"
        end
        url = url.gsub("key", key[(home_team.id-1)/3])
        puts url

        require 'open-uri'
        require 'json'
        open(url) do |f|
          json_string = f.read
          parsed_json = JSON.parse(json_string)
          forecast_data = parsed_json['hourly_forecast']
          (1..3).each do |i|
            hour_data = forecast_data.detect{|w| w['FCTTIME']['hour'].to_i == game_hour && w['FCTTIME']['mday'].to_i == day}
            if hour_data
              Weather.create(game: game, station: "Forecast", hour: i)
              weather = game.weathers.where(station: "Forecast").where(hour: i).order(:created_at).last
              weather.update(temp: "#{hour_data['temp']['english']} °C", humidity: "#{hour_data['humidity']}%", rain: 0, wind: "#{hour_data['wspd']['english']} mph #{hour_data['wdir']['dir']}", feel: "#{hour_data['feelslike']['english']} °C", dew: "#{hour_data['dewpoint']['english']} °C", pressure: "#{hour_data['mslp']['english']} in")
            else
              break
            end
            game_hour = game_hour + 1
          end
        end
      end
    
	    def convert_to_military_hour(hour, period)
	  	  if period == "PM" && hour != 12
	        hour += 12
	      end
	      hour
	    end
  end
end