require './lib/shows'

RSpec.describe Shows do
  let(:mock_shows) { double(:array_of_shows) }
  subject(:shows) { Shows.new(mock_shows) }

  describe '.from' do
    let(:test_path) { './spec/fixtures/ten_netflix_titles.csv' }

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