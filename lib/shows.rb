require 'forwardable'
require 'ostruct'
require 'csv'
# Parses shows from a CSV and presents them

class Shows
  extend Forwardable
  delegate [:length, :each, :[]] => :@shows

  def initialize(shows)
    @shows = shows
  end

  def self.from(path, limit: nil)
    enum = CSV.foreach(path, headers: true)

    rows = limit ? enum.take(limit) : enum

    new(rows.map { |row| build_show(row) })
  end

  def self.import(path, model: Show)
    CSV.foreach(path, headers: true) do |row|
      show = build_show(row)

      model.create(
        show_type: show.type,
        title: show.title,
        director: show.director,
        cast: show.cast,
        country: show.country,
        date_added: Date.parse(show.date_added),
        release_year: show.release_year.to_i,
        rating: show.rating,
        duration: show.duration,
        listed_in: show.listed_in,
        description: show.description
      )
    end
  end

  private

  def self.build_show(row)
    OpenStruct.new(
      row.reduce({}) do |properties, (header, field)|
        properties[header] = field
        properties
      end
    )
  end
end