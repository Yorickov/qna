class SearchController < ApplicationController
  def index
    render plain: "Sorry, Search doesn't work on Heroku"
    # @query = search_params[:q]
    # @search_result = SearchService.call(search_params)
  end

  private

  def search_params
    params.require(:search).permit(:q, :resource)
  end
end
