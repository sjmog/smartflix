require './lib/shows'

class ShowsController < ApplicationController
  def index
    @shows = Shows.from('./data/netflix_titles.csv', limit: 10)
  end
end