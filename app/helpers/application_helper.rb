module ApplicationHelper
  def controller_classes
    "p-#{controller_name} p-#{controller_name}-#{action_name}"
  end
end
