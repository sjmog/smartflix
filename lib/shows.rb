require 'forwardable'
require 'ostruct'
require 'csv'
# Parses shows from a CSV and presents them

class Shows
  extend Forwardable
  delegate [:length, :each, :each_with_index, :[]] => :@shows

  def initialize(shows)
    @shows = shows
  end

  def self.from(path, limit: nil)
    enum = CSV.foreach(path, headers: true)

    rows = limit ? enum.take(limit) : enum

    new(rows.map { |row| build_show(row) })
  end

  def self.import(path, model: Show, logging: false, logger: STDOUT)
    enum = CSV.foreach(path, headers: true)

    if logging
      number_of_shows = enum.count
      logger.print("Importing #{ number_of_shows } shows...\n")
    end

    enum.each_with_index do |row, index|
      show = build_show(row)

      if logging
        logger.print("Importing #{show.title} (#{index + 1} / #{number_of_shows})\n")
      end

      success = model.find_or_create_by(
        show_type: show.type,
        title: show.title,
        director: show.director,
        cast: show.cast,
        country: show.country,
        date_added: Date.parse(show.date_added || Time.at(0).to_date.to_s),
        release_year: show.release_year.to_i,
        rating: show.rating,
        duration: show.duration,
        listed_in: show.listed_in,
        description: show.description
      )
    end

    if logging
      logger.print("Successfully imported #{number_of_shows} shows!\n")
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