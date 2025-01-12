class MoviesController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'cgi'

  def search
    query = params[:query]
    language = params[:language] || "en" # default if not provided

    tmdb_movie_results = fetch_tmdb_results(query, language)
    tmdb_tv_results = fetch_tmdb_tv_results(query, language)
    tvmaze_results = language == "en" ? fetch_tvmaze_results(query) : []

    # combine, limit results
    render json: (tmdb_movie_results + tmdb_tv_results + tvmaze_results).take(10)
  end

  private

  def fetch_tmdb_results(query, language)
    url = "https://tmdb.lewagon.com/search/movie?query=#{CGI.escape(query)}&language=#{language}"
    response = URI.open(url).read
    JSON.parse(response)["results"].map do |movie|
      next if language == "ja" && movie["original_language"] != "ja" # skip non-Japanese result

      {
        id: movie["id"],
        source: "tmdb",
        title: movie["title"], # localised title
        release_date: movie["release_date"],
        overview: sanitize_text(movie["overview"]) # sanitise overview
      }
    end.compact
  rescue => e
    Rails.logger.error("TMDB API Error: #{e.message}")
    []
  end

  def fetch_tmdb_tv_results(query, language)
    url = "https://tmdb.lewagon.com/search/tv?query=#{CGI.escape(query)}&language=#{language}"
    response = URI.open(url).read
    JSON.parse(response)["results"].map do |tv_show|
      {
        id: tv_show["id"],
        source: "tmdb_tv",
        title: tv_show["name"], # localised title
        release_date: tv_show["first_air_date"],
        overview: sanitize_text(tv_show["overview"]) # sanitise overview
      }
    end
  rescue => e
    Rails.logger.error("TMDB TV API Error: #{e.message}")
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
        overview: sanitize_text(show["summary"]) # sanitise overview
      }
    end
  rescue => e
    Rails.logger.error("TVMaze API Error: #{e.message}")
    []
  end

  # helper to sanitise text
  def sanitize_text(text)
    text&.gsub(/<\/?[^>]*>/, "")&.strip # remove HTML tags and trim whitespace
  end


end
