class ShowsController < ApplicationController
  def index
    @shows = Show.all.limit(10)
  end
end