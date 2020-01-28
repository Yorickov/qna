module ApplicationHelper
  def calc_flash_type(type)
    case type
    when 'alert'
      'danger'
    when 'notice'
      'success'
    end
  end
end
