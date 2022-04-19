require './lib/shows'
require 'rails_helper'

RSpec.describe Shows do
  let(:mock_shows) { double(:array_of_shows) }
  subject(:shows) { Shows.new(mock_shows) }

  describe 'Class methods' do
    let(:test_path) { './spec/fixtures/ten_netflix_titles.csv' }

    describe '.from' do
      it 'Sets up shows for each show in the CSV' do
        expect(Shows.from(test_path).length).to eq(10)
      end

      it 'Can be configured with a limit' do
        expect(Shows.from(test_path, limit: 5).length).to eq(5)
      end

      it 'sets the CSV headers as methods on the show objects' do
        Shows.from(test_path).each do |show|
          expect(show).to respond_to(:show_id)
          expect(show).to respond_to(:type)
          expect(show).to respond_to(:title)
          expect(show).to respond_to(:director)
          expect(show).to respond_to(:cast)
          expect(show).to respond_to(:country)
          expect(show).to respond_to(:date_added)
          expect(show).to respond_to(:release_year)
          expect(show).to respond_to(:rating)
          expect(show).to respond_to(:duration)
          expect(show).to respond_to(:listed_in)
          expect(show).to respond_to(:description)
        end
      end
    end

    describe '.import' do
      it 'Creates database entries for each show in the CSV' do
        mock_db_model = double(:Show, create: nil)
        Shows.import(test_path, model: mock_db_model)

        expect(mock_db_model).to have_received(:create).exactly(Shows.from(test_path).length).times
      end

      it 'Configures the database entry correctly' do
        shows = Shows.from(test_path)
        Shows.import(test_path)

        Show.all.each_with_index do |db_show, index|
          csv_show = shows[index]

          expect(db_show.show_type).to eq csv_show.type
          expect(db_show.title).to eq csv_show.title
          expect(db_show.director).to eq csv_show.director
          expect(db_show.cast).to eq csv_show.cast
          expect(db_show.country).to eq csv_show.country
          expect(db_show.date_added).to eq Date.parse(csv_show.date_added)
          expect(db_show.release_year).to eq csv_show.release_year.to_i
          expect(db_show.rating).to eq csv_show.rating
          expect(db_show.duration).to eq csv_show.duration
          expect(db_show.listed_in).to eq csv_show.listed_in
          expect(db_show.description).to eq csv_show.description
        end
      end
    end
  end

  describe 'delegating methods to the internal array of shows' do
    it '#length' do
      expect(mock_shows).to receive(:length)
      shows.length
    end

    it '#each' do
      expect(mock_shows).to receive(:each)
      shows.each
    end
  end
end