# frozen_string_literal: true

class InvoicesController < ApplicationController
  def show
  end

  def new
    # t.bigint "invoice_category_id", null: false
    # t.string "vat_id"
    # t.string "invoice_number"
    # t.string "tax_id"
    # t.decimal "vat", precision: 5, scale: 2
    # t.decimal "vat_rate", precision: 5, scale: 2
    # t.boolean "vat_included", default: false

    @invoice = Invoice.new
    @invoice.line_items.build
  end

  def create
    Invoice.create(invoice_params.merge(user: current_user, invoice_category: InvoiceCategory.first))
  end

  private

  def invoice_params
    params.require(:invoice).permit(:date, :due_date, :tax, :discount, :grand_total, line_items_attributes:)
  end

  def line_items_attributes
    [:description, :quantity, :unit_price, :total_price, :_destroy]
  end
end
