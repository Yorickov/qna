module ApplicationHelper
  def calc_flash_type(type)
    case type
    when 'alert' then 'danger'
    when 'notice' then 'success'
    end
  end

  def check_author(resource)
    user_signed_in? && current_user.author_of?(resource)
  end
end
