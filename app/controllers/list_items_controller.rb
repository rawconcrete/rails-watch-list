class ListItemsController < ApplicationController
  class ListItemsController < ApplicationController
    def create
      @list_item = ListItem.new(list_item_params)

      if @list_item.save
        redirect_back fallback_location: search_path, notice: "successfully added."
      else
        redirect_back fallback_location: search_path, alert: "add failed."
      end
    end

    private

    def list_item_params
      params.require(:list_item).permit(:title, :overview, :poster_url, :rating)
    end
  end
end
