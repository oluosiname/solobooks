# frozen_string_literal: true

module BankConnectionsHelper
  def bank_connection_status_tag(bank_connection)
    icon_class = bank_connection.active? ? 'fa-regular fa-circle-check' : 'fa-regular fa-circle-xmark'
    text_color = bank_connection.active? ? 'text-green-400' : 'text-danger-400'
    status_text = bank_connection.active? ? 'Connected' : 'Disconnected'

    content_tag(:div, class: 'flex gap-2') do
      content_tag(:i, nil, class: "#{icon_class} #{text_color}") +
        content_tag(:span, status_text, class: 'text-sm text-gray-600 capitalize')
    end
  end
end
