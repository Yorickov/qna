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
end
