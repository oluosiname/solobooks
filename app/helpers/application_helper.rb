# frozen_string_literal: true

module ApplicationHelper
  BADGE_STATUS = {
    'pending' => 'bg-grey-600',
    'paid' => 'bg-green-700',
    'due' => 'bg-danger-700',
    'cancelled' => 'bg-tertiary-700',
    'refunded' => 'bg-tertiary-700',
  }
  def display_status(status)
    content_tag(:span, status.capitalize, class: "badge #{BADGE_STATUS[status]}")
  end
end
