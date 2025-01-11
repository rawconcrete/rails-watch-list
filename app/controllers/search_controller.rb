class SearchController < ApplicationController
  require 'cgi'
  require 'open-uri'
  require 'json'

  TMDB_BASE_URL = "https://tmdb.lewagon.com"
  TVMAZE_BASE_URL = "http://api.tvmaze.com"

  def index
    if params[:query].present?
      @tmdb_results = search_tmdb(params[:query])
      @tvmaze_results = search_tvmaze(params[:query])
    else
      @tmdb_results = []
      @tvmaze_results = []
    end
  end

  private

  def search_tmdb(query)
    url = "#{TMDB_BASE_URL}/search/movie?query=#{CGI.escape(query)}"
    response = URI.open(url).read
    JSON.parse(response)['results']
  rescue => e
    Rails.logger.error("TMDB API Error: #{e.message}")
    []
  end

  def search_tvmaze(query)
    url = "#{TVMAZE_BASE_URL}/search/shows?q=#{CGI.escape(query)}"
    response = URI.open(url).read
    JSON.parse(response).map { |result| result['show'] }
  rescue => e
    Rails.logger.error("TVmaze API Error: #{e.message}")
    []
  end
end
