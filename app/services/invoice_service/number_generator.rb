# frozen_string_literal: true

module InvoiceService
  class NumberGenerator < ApplicationService
    def call
      loop do
        number = SecureRandom.hex(3).upcase
        break number unless Invoice.exists?(invoice_number: number)
      end
    end
  end
end
