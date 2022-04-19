require 'forwardable'
require 'ostruct'
require 'csv'
# Parses shows from a CSV and presents them

class Shows
  extend Forwardable
  delegate [:length, :each] => :@shows

  def initialize(shows)
    @shows = shows
  end

  def self.from(path, limit: nil)
    enum = CSV.foreach(path, headers: true)

    rows = limit ? enum.take(limit) : enum

    new(rows.map { |row| build_show(row) })
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