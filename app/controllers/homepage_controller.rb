require './lib/shows'

class HomepageController < ApplicationController
  def index
    @shows = Shows.from('./data/netflix_titles.csv', limit: 10)
  end
end