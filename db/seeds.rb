# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'
require 'json'

class SearchService
  TMDB_BASE_URL = "https://tmdb.lewagon.com"
  TVMAZE_BASE_URL = "http://api.tvmaze.com"

  def self.search_tmdb(query)
    url = "#{TMDB_BASE_URL}/search/movie?query=#{URI.encode(query)}"
    response = URI.open(url).read
    JSON.parse(response)['results']
  end

  def self.search_tvmaze(query)
    url = "#{TVMAZE_BASE_URL}/search/shows?q=#{URI.encode(query)}"
    response = URI.open(url).read
    JSON.parse(response).map { |result| result['show'] }
  end
end
