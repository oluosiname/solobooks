# frozen_string_literal: true

module InvoiceService
  class PdfAttacher < ApplicationService
    def initialize(invoice:, pdf_path:)
      @invoice = invoice
      @pdf_path = pdf_path
    end

    def call
      invoice.pdf.attach(
        io: File.open(pdf_path),
        filename: "Invoice - #{@invoice.invoice_number}",
        content_type: 'application/pdf'
      )
    end

    private

    attr_reader :invoice, :pdf_path

  end
end
