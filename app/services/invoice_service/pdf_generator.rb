# frozen_string_literal: true

module InvoiceService
  class PdfGenerator < ApplicationService
    include ActionView::Helpers::NumberHelper

    FONT_SIZE_MD = 10
    FONT_COLOUR = '2f333c'
    TABLE_HEADING = ['ITEM', 'QTY', 'RATE', 'AMOUNT'].freeze

    def initialize(invoice:)
      @invoice = invoice
    end

    def call
      @pdf = Prawn::Document.new
      pdf.font_families.update('Baloo' => {
        normal: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-Regular.ttf'),
        bold: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-Bold.ttf'),
        semi_bold: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-SemiBold.ttf'),
        medium: Rails.root.join('app/assets/fonts/Baloo_2/static/Baloo2-Medium.ttf'),
      })
      pdf.font 'Baloo'
      pdf.font_size FONT_SIZE_MD
      pdf.fill_color FONT_COLOUR
      last_measured_y = pdf.cursor
      pdf.image "#{Rails.root.join("app/assets/images/logo-dark.png")}", position: :left, width: 80
      pdf.text_box 'Invoice #', size: 16, style: :semi_bold, at: [0, last_measured_y], align: :right
      last_measured_y = pdf.cursor - 7
      pdf.formatted_text_box [{ text: 'MyraStudio Inc.', color: '256094' }], style: :semi_bold, at: [0, last_measured_y]
      pdf.formatted_text_box [{ text: invoice.invoice_number, color: '727d92' }],
        at: [0, last_measured_y],
        align: :right
      pdf.move_down 40

      # User Address
      last_measured_y = pdf.cursor
      pdf.formatted_text_box [{ text: 'Konrad Wolf-Str 90' }], align: :right, at: [0, last_measured_y]
      pdf.formatted_text_box [{ text: '13055, Berlin' }], at: [0, last_measured_y - 17], align: :right
      pdf.formatted_text_box [{ text: 'Germany' }], at: [480, last_measured_y - 34], align: :right
      pdf.move_down 60

      # Client Info
      last_measured_y = pdf.cursor
      pdf.text I18n.t('invoices.show.bill_to'), size: 12, style: :semi_bold
      pdf.text "#{invoice.client.name}", size: 11, style: :semi_bold

      pdf.move_down 10
      pdf.text '1274 Stark Hollow Road,'
      pdf.text 'Binghamton, NY 13901'
      pdf.text 'United States'
      pdf.text "VAT ID: #{invoice.client.vat_number}" if invoice.client.vat_number.present?
      pdf.move_down 10

      # Dates
      pdf.formatted_text_box(
        [
          { text:  'Invoice Date:     ', styles: [:bold] },
          { text:  invoice.date.strftime('%d/%m/%Y') },
        ],
        align: :right,
        at: [0, last_measured_y],
      )
      pdf.formatted_text_box(
        [
          { text:  'Due Date:     ', styles: [:bold] },
          { text:  invoice.due_date.strftime('%d/%m/%Y') },
        ],
        align: :right,
        at: [0, last_measured_y - 25],
      )

      # Line items Table
      t = pdf.table line_items_table_data, line_items_table_props do
        column(3).style align: :right
        # row(0..-1).border_width = 0
        # row(1).border_width = 0
        row(0).style background_color: 'f0f0f0', font_style: :semi_bold
      end

      pdf.move_down 20

      # Payment Details
      pdf.text 'Payment Details', size: 12, style: :semi_bold

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
      pdf.text I18n.t('invoices.show.reverse_vat'), color: '727d92', align: :right

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
        ['Subtotal:', number_to_currency(invoice.subtotal, unit: invoice.currency_symbol)],
        ["VAT (#{invoice.vat_rate.to_i}%):", number_to_currency(invoice.vat, unit: invoice.currency_symbol)],
        ['Total:', number_to_currency(invoice.total_amount, unit: invoice.currency_symbol)],
        # ['Amount Due', number_to_currency(invoice.total, unit: invoice.currency_symbol)],
        # ['Amount Paid', number_to_currency(0, unit: invoice.currency_symbol)],
      ]
    end

    def payments_details_table_data
      [
        ['Bank Name:', 'Deutsche Bank'],
        ['Account Number:', '1234567890'],
        ['IBAN:', 'DE12345678901234567890'],
        ['SWIFT/BIC:', 'DEUTDEFFXXX'],
      ]
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
          line_item.quantity,
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
          pdf.text 'Telephone No: +4915222456466'
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

    attr_reader :invoice, :pdf
  end
end
