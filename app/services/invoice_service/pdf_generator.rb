# frozen_string_literal: true

require 'open-uri'
module InvoiceService
  class PdfGenerator < ApplicationService
    include ActionView::Helpers::NumberHelper

    FONT_SIZE_MD = 10
    FONT_COLOUR = '2f333c'
    TABLE_HEADING = [
      I18n.t('invoices.show.line_items_table.heading.item'),
      I18n.t('invoices.show.line_items_table.heading.qty'),
      I18n.t('invoices.show.line_items_table.heading.rate'),
      I18n.t('invoices.show.line_items_table.heading.subtotal'),
    ].freeze

    def initialize(invoice:)
      @invoice = invoice
    end

    def call
      @pdf = Prawn::Document.new
      pdf.font_families.update('Baloo' => fonts)
      pdf.font 'Baloo'
      pdf.font_size FONT_SIZE_MD
      pdf.fill_color FONT_COLOUR

      last_measured_y = pdf.cursor

      if user_profile.logo.attached?
        logo_url = Rails.application.routes.url_helpers.rails_blob_url(user_profile.logo, only_path: false)
        logo_image = URI.open(logo_url) # rubocop:disable Security/Open
        pdf.image logo_image, position: :left, width: 80
      end
      old_last_measured_y = last_measured_y
      last_measured_y = pdf.cursor - 7
      pdf.formatted_text_box [{ text: user_profile.name, color: '256094' }], style: :semi_bold, at: [0, last_measured_y]

      pdf.text_box 'Invoice #', size: 16, style: :semi_bold, at: [0, old_last_measured_y], align: :right

      last_measured_y = old_last_measured_y - 25
      pdf.formatted_text_box [{ text: invoice.invoice_number, color: '727d92' }],
        at: [0, last_measured_y],
        align: :right
      # pdf.move_down 20

      # # User Address
      # last_measured_y = pdf.cursor
      pdf.formatted_text_box [{ text: user_address.street_address }], align: :right, at: [0, last_measured_y - 30]
      pdf.formatted_text_box [{ text: [user_address.city, user_address.state, user_address.postal_code].join(', ') }],
        at: [0, last_measured_y - 47],
        align: :right
      pdf.formatted_text_box [{ text: user_address.country_name }], at: [480, last_measured_y - 64], align: :right
      pdf.move_down 40

      # Client Info
      last_measured_y = pdf.cursor
      pdf.text I18n.t('invoices.show.bill_to'), size: 12, style: :semi_bold
      pdf.text invoice.client.name.to_s, size: 11, style: :semi_bold

      pdf.move_down 10
      pdf.text client_address.street_address
      pdf.text [client_address.city, client_address.state, client_address.postal_code].join(', ')
      pdf.text client_address.country_name
      pdf.text "VAT ID: #{invoice.client.vat_number}" if invoice.client.vat_number.present?
      pdf.move_down 10

      # Dates
      pdf.formatted_text_box(
        [
          { text:  "#{I18n.t("activerecord.attributes.invoice.date")}:     ", styles: [:bold] },
          { text:  invoice.date.strftime('%d/%m/%Y') },
        ],
        align: :right,
        at: [0, last_measured_y],
      )
      pdf.formatted_text_box(
        [
          { text:  "#{I18n.t("activerecord.attributes.invoice.due_date")}:     ", styles: [:bold] },
          { text:  invoice.due_date.strftime('%d/%m/%Y') },
        ],
        align: :right,
        at: [0, last_measured_y - 25],
      )

      # Line items Table
      pdf.table line_items_table_data, line_items_table_props do
        column(3).style align: :right
        # row(0..-1).border_width = 0
        # row(1).border_width = 0
        row(0).style background_color: 'f0f0f0', font_style: :semi_bold
      end

      pdf.move_down 20

      # Payment Details
      pdf.text I18n.t('invoices.show.payment_details'), size: 12, style: :semi_bold

      last_measured_y = pdf.cursor
      payment_table = pdf.make_table payments_details_table_data, payment_details_table_props do
        column(0).style font_style: :semi_bold
        column(0).style align: :left
        column(1).style align: :left
      end
      if pdf.cursor - payment_table.height < 0
        pdf.start_new_page
      end

      payment_table.draw

      pdf.move_up last_measured_y - pdf.cursor + 20
      # Totals Table
      pdf.table totals_table_data, totals_table_props do
        column(0).style align: :right
        column(1).style align: :right
        # column(0).style font_style: :semi_bold
        cells[2, 1].style font_style: :semi_bold, size: 11
      end
      pdf.move_down 20
      pdf.text I18n.t("activerecord.attributes.invoice.vat_techniques.#{invoice.vat_technique}"),
        color: '727d92',
        align: :right

      pdf.move_down 40

      pdf.move_down 10

      pdf.repeat(:all) do
        display_footer
      end

      pdf.bounding_box([0, 610], width: 550, height: 620) do
        display_page_numbers
      end
      pdf
    end

    private

    def line_items_table_props
      {
        position: :center,
        width: pdf.bounds.width,
        column_widths: [250, 50, 100, 140],
        cell_style: {
          padding: [2, 7, 7, 2],
          border_width: 0,
        },
      }
    end

    def totals_table_props
      {
        position: :right,
        width: 250,
        column_widths: [175, 75],
      }
    end

    def totals_table_data
      [
        [
          "#{I18n.t("activerecord.attributes.invoice.subtotal")}:",
          number_to_currency(invoice.subtotal, unit: invoice.currency_symbol),
        ],
        [
          "#{I18n.t("activerecord.attributes.invoice.vat")} (#{invoice.vat_rate.to_i}%):",
          number_to_currency(invoice.vat, unit: invoice.currency_symbol),
        ],
        [
          "#{I18n.t("activerecord.attributes.invoice.total")}:",
          number_to_currency(invoice.total_amount, unit: invoice.currency_symbol),
        ],
      ]
    end

    def payments_details_table_data
      [:bank_name, :account_holder, :account_number, :iban, :swift].map do |key|
        value = payment_details.send(key)
        next if value.blank?

        [I18n.t("activerecord.attributes.payment_detail.#{key}"), value]
      end.compact
    end

    def payment_details_table_props
      {
        position: :left,
        width: 250,
        column_widths: [100, 150],
        cell_style: {
          border_width: 0,
          padding: [0, 7, 7, 0],
          # height: 30,
        },
      }
    end

    def formatted_key_value(key, value, y_position)
      pdf.formatted_text_box(
        [
          { text:  "#{key}:     ", styles: [:bold] },
          { text:  value },
        ],
        align: :left,
        at: [0, y_position],
      )
    end

    def line_items_table_data
      line_items_table_header + line_items_rows
    end

    def line_items_table_header
      [TABLE_HEADING]
    end

    def line_items_rows
      invoice.line_items.map do |line_item|
        [
          line_item.description,
          "#{line_item.quantity} #{line_item.unit}",
          number_to_currency(line_item.unit_price, unit: invoice.currency_symbol),
          number_to_currency(line_item.total_price, unit: invoice.currency_symbol),
        ]
      end
    end

    def display_footer
      pdf.bounding_box([0, pdf.bounds.bottom + 30], width: 550, height: 80) do
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        pdf.font_size 9 do
          pdf.text I18n.t('invoices.show.thanks.content')
          pdf.move_down 5
          pdf.text "Email Address: #{@invoice.user.email}"
          pdf.text "Telephone No: #{user_profile.phone_number}"
        end
      end
    end

    def display_page_numbers
      options = {
        at: [pdf.bounds.right - 150, 0],
        width: 150,
        align: :right,
        start_count_at: 1,
        color: '727d92',
        size: 8,
      }
      pdf.number_pages 'Page <page> of <total>', options
    end

    def fonts
      {
        normal: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-Regular.ttf'),
        bold: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-Bold.ttf'),
        semi_bold: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-SemiBold.ttf'),
        medium: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-Medium.ttf'),
      }
    end

    def client_address
      @client_address ||= invoice.client.address
    end

    def user
      @user ||= invoice.user
    end

    def user_profile
      @user_profile ||= user.profile
    end

    def user_address
      @user_address ||= user_profile.address
    end

    def payment_details
      @payment_details ||= user.payment_detail
    end

    attr_reader :invoice, :pdf
  end
end
