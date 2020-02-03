module ApplicationHelper
  def calc_flash_type(type)
    case type
    when 'alert' then 'danger'
    when 'notice' then 'success'
    end
  end
end
