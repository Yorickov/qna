module SearchHelper
  def indexed_collection
    SearchService::INDEXED_RESOURCES
      .keys
      .unshift('all')
      .map { |key| [I18n.t("helpers.#{key}"), key] }
  end
end
