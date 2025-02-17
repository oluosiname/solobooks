# frozen_string_literal: true

module BankConnectionsHelper
  CONNECTION_ICONS_CSS = {
    active: 'fa-regular fa-circle-check text-green-400',
    inactive: 'fa-solid fa-triangle-exclamation text-yellow-400',
    error: 'fa-regular fa-circle-xmark text-danger-400',
    disconnected: 'fa-regular fa-circle-xmark text-danger-400',
  }.freeze


  def bank_connection_status_tag(bank_connection)
    content_tag(:div, class: 'flex gap-2') do
      content_tag(:i, nil, class: CONNECTION_ICONS_CSS[bank_connection.status.to_sym]) +
        content_tag(:span, bank_connection.status, class: 'text-sm text-gray-600 capitalize')
    end
  end
end
