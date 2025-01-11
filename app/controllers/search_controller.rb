class SearchController < ApplicationController
  class SearchController < ApplicationController
    def index
      query = params[:query]
      @tmdb_results = SearchService.search_tmdb(query)
      @tvmaze_results = SearchService.search_tvmaze(query)
    end
  end
end
