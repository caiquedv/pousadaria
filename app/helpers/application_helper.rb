module ApplicationHelper
  def boolean_to_human(value)
    value ? 'Sim' : 'Não'
  end

  def formatted_date(date)
    date.strftime("%d/%m/%Y") if date
  end
end
