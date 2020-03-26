module SearchHelper
  def indexed_collection
    SearchService::INDEXED_RESOURCES.keys.unshift('all')
  end
end
