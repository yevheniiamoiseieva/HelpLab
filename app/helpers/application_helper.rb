module ApplicationHelper
  def status_color(status)
    case status
    when 'Потрібна допомога' then 'bg-red-100 text-red-800'
    when 'У процесі' then 'bg-yellow-100 text-yellow-800'
    when 'Завершено' then 'bg-green-100 text-green-800'
    else 'bg-gray-100 text-gray-800'
    end
  end
end
