class BookmarksController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'cgi'

  def new
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
    @search_results = search_movies(params[:query], params[:language]) if params[:query].present?
  end

  def create
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    if @bookmark.save
      redirect_to list_path(@list), notice: 'Bookmark was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
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

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id)
  end
end
