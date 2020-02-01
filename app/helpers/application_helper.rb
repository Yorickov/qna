module ApplicationHelper
  def calc_flash_type(type)
    case type
    when 'alert' then 'danger'
    when 'notice' then 'success'
    end
  end

  def check_entity_author(entity)
    user_signed_in? && current_user.entity_author?(entity)
  end
end
