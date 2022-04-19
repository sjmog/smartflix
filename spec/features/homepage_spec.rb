require 'rails_helper'
require './lib/shows'

feature "Visiting the homepage" do
  scenario "See the homepage header" do
    visit "/"
    expect(page).to have_content "Smartflix"
  end

  scenario "See the show titles in the CSV" do
    visit "/"

    Shows.from('data/netflix_titles.csv', limit: 10).each do |show|
      expect(page).to have_content show.title
    end
  end
end