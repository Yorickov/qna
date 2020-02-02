module ApplicationHelper
  def calc_flash_type(type)
    case type
    when 'alert' then 'danger'
    when 'notice' then 'success'
    end
  end

  def resource_author_present?(resource)
    current_user&.author_of?(resource)
  end
end
