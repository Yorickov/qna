class SearchController < ApplicationController
  def index
    @query = search_params[:q]
    @search_result = SearchService.call(search_params)
  end

  private

  def search_params
    params.require(:search).permit(:q, :resource)
  end
end
