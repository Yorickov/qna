class SearchService
  INDEXED_RESOURCES = {
    'question' => Question,
    'answer' => Answer,
    'comment' => Comment,
    'user' => User
  }.freeze

  def self.call(search_params)
    resource = search_params[:resource]
    query = search_params[:q]

    searching_klass = INDEXED_RESOURCES.fetch(resource, ThinkingSphinx)
    searching_klass.search ThinkingSphinx::Query.escape(query)
  end
end
