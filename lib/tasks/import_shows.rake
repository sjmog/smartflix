require './lib/shows'

desc "Import shows from a CSV to the database."
task :import_shows => :environment do
  Shows.import('./data/netflix_titles.csv', logging: true)
end