# frozen_string_literal: true

module InvoiceService
  class PdfAttacher < ApplicationService
    def initialize(invoice:, pdf:)
      @invoice = invoice
      @pdf = pdf
    end

    def call
      invoice.pdf.attach(
        io: pdf,
        filename: "Invoice - #{@invoice.invoice_number}",
        content_type: 'application/pdf',
      )
    end

    private

    attr_reader :invoice, :pdf
  end
end
