# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  PAGE_TOKEN  = '__pagy_page__'
  LABEL_TOKEN = '__pagy_label__'

  BADGE_STATUS = {
    'draft' => 'bg-grey-400 text-grey-900',
    'sent' => 'bg-grey-600 text-white',
    'paid' => 'bg-green-700 text-white',
    'overdue' => 'bg-danger-700 text-white',
    'cancelled' => 'bg-tertiary-700 text-white',
  }

  def display_status(status)
    content_tag(
      :span,
      t("activerecord.attributes.invoice.statuses.#{status}").capitalize,
      class: "badge #{BADGE_STATUS[status]}",
    )
  end

  def locale_selector_class(locale)
    return 'text-grey-900 font-semibold' if I18n.locale == locale

    'text-grey-600'
  end

  def pagy_info(pagy, id: nil, item_name: nil)
    %(<span#{id} class="pagy info">#{pagy.from}-#{pagy.to} of #{pagy.count}</span>)
  end

  def presigned_url(blob, disposition: 'attachment', expires_in: 10.minutes)
    blob.url(disposition: disposition, expires_in:)
  end
end
