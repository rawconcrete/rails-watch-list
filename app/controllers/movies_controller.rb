class MoviesController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'cgi'

  def search
    query = params[:query]
    tmdb_results = fetch_tmdb_results(query)
    tvmaze_results = fetch_tvmaze_results(query)

    # combine results, return JSON
    render json: (tmdb_results + tvmaze_results).take(10) # limit to 10
  end

  private

  def fetch_tmdb_results(query)
    url = "https://tmdb.lewagon.com/search/movie?query=#{CGI.escape(query)}"
    response = URI.open(url).read
    JSON.parse(response)["results"].map do |movie|
      {
        id: movie["id"],
        source: "tmdb",
        title: movie["title"],
        release_date: movie["release_date"],
        overview: movie["overview"]
      }
    end
  rescue => e
    Rails.logger.error("TMDB API Error: #{e.message}")
    []
  end

  def fetch_tvmaze_results(query)
    url = "https://api.tvmaze.com/search/shows?q=#{CGI.escape(query)}"
    response = URI.open(url).read
    JSON.parse(response).map do |result|
      show = result["show"]
      {
        id: show["id"],
        source: "tvmaze",
        title: show["name"],
        release_date: show["premiered"],
        overview: show["summary"]&.gsub(/<\/?[^>]*>/, "") # remove HTML
      }
    end
  rescue => e
    Rails.logger.error("TVMaze API Error: #{e.message}")
    []
  end
end
