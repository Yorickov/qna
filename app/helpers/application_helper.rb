module ApplicationHelper
  def calc_flash_type(type)
    case type
    when 'alert' then 'danger'
    when 'notice' then 'success'
    end
  end

  def format_time(timestamp)
    timestamp.strftime('%d.%m.%Y, %H:%M')
  end

  def github_url(author, repo, options = {})
    link_to author,
            "https://github.com/#{author}/#{repo}",
            target: '_blank',
            **options
  end

  def current_year
    Date.current.in_time_zone.year
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
