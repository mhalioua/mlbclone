class CalcController < ApplicationController
  require 'date'

  def input
  	@post = params
    @team_dropdown = [
		['Angels', 'Angels'],
		['Astros', 'Astros'],
		['Athletics', 'Athletics'],
		['Blue Jays', 'Blue Jays'],
		['Braves', 'Braves'],
		['Brewers', 'Brewers'],
		['Cardinals', 'Cardinals'],
		['Cubs', 'Cubs'],
		['Diamondbacks', 'Diamondbacks'],
		['Dodgers', 'Dodgers'],
		['Giants', 'Giants'],
		['Indians', 'Indians'],
		['Mariners', 'Mariners'],
		['Marlins', 'Marlins'],
		['Mets', 'Mets'],
		['Nationals', 'Nationals'],
		['Orioles', 'Orioles'],
		['Padres', 'Padres'],
		['Phillies', 'Phillies'],
		['Pirates', 'Pirates'],
		['Rangers', 'Rangers'],
		['Rays', 'Rays'],
		['Red Sox', 'Red Sox'],
		['Reds', 'Reds'],
		['Rockies', 'Rockies'],
		['Royals', 'Royals'],
		['Tigers', 'Tigers'],
		['Twins', 'Twins'],
		['White Sox', 'White Sox'],
		['Yankees', 'Yankees']
	]
  end
end
