require 'rails_helper'

feature "Homepage" do
  scenario "Visiting the homepage" do
    visit "/"
    expect(page).to have_content "Smartflix"
  end
end