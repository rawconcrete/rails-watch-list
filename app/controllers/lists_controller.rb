class ListsController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'cgi'

  def index
    @lists = List.all
    @search_results = search_movies(params[:query], params[:language]) if params[:query].present?
  end

  def new
    @list = List.new
  end

  def show
    @list = List.find(params[:id])
  end

  private

  def search_movies(query, language = "en")
    url = "https://tmdb.lewagon.com/search/movie?query=#{CGI.escape(query)}&language=#{language}"
    response = URI.open(url).read
    JSON.parse(response)['results']
  rescue => e
    Rails.logger.error("TMDB API Error: #{e.message}")
    []
  end
end
