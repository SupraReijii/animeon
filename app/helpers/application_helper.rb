# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def controller_classes
    "p-#{controller_name} p-#{controller_name}-#{action_name}"
  end

  def user_signed_as_admin?
    return true if user_signed_in? && current_user.role == 'admin'

    false
  end

  def user_signed_as_creator?
    return true if user_signed_in? && current_user.role == 'creator'

    false
  end
end
