module ApplicationHelper
  def boolean_to_human(value)
    value ? 'Sim' : 'Não'
  end
end
