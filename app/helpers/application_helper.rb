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

  def count_key count
    if count.is_a?(Integer) || count.is_a?(Float)
      I18n.russian? ? ru_count_key(count) : en_count_key(count)
    else
      I18n.russian? ? count : (RU_COUNT_KEYS_TO_EN[count] || count)
    end
  end
  def i18n_i(key, count = 1, ru_case = :subjective)
    count_key = count_key count

    translation =
      if I18n.russian?
        I18n.t(
          "inflections.cardinal.#{key.downcase}.#{ru_case}.#{count_key}",
          default: "inflections.cardinal.#{key.downcase}.default"
        )
      else
        default = key.to_s.tr('_', ' ').pluralize(count_key == :one ? 1 : 2)
        I18n.t("inflections.#{key.downcase}.#{count_key}", default:)
      end

    key == key.downcase ? translation : translation.capitalize
  end
  def ru_count_key count
    number = count % 100
    return :many if number >= 5 && number <= 20

    number %= 10

    if number == 1
      :one
    elsif number >= 2 && number <= 4
      :few
    else
      :many
    end
  end

  def en_count_key count
    if count.zero?
      :zero
    elsif count == 1
      :one
    else
      :other
    end
  end
end
