# frozen_string_literal: true

module ApplicationHelper
  BADGE_STATUS = {
    'sent' => 'bg-grey-600',
    'paid' => 'bg-green-700',
    'due' => 'bg-danger-700',
    'cancelled' => 'bg-tertiary-700',
    'refunded' => 'bg-tertiary-700',
  }
  def display_status(status)
    content_tag(
      :span,
      t("activerecord.attributes.invoice.statuses.#{status}").capitalize,
      class: "badge #{BADGE_STATUS[status]}",
    )
  end
end
