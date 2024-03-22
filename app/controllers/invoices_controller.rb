# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :set_select_options, only: [:new, :create]

  def index
    @invoices = current_user.invoices.filtered(filter_params).includes(:client, :currency)
  end

  def show
  end

  def new
    @invoice = Invoice.new
    @invoice.line_items.build
  end

  def create
    @invoice = Invoice.new(invoice_params.merge(user: current_user))
    if @invoice.save
      redirect_to invoice_path(@invoice)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      :date,
      :due_date,
      :tax,
      :currency_id,
      :language,
      :invoice_category_id,
      :vat_rate,
      :client_id,
      :vat_included,
      line_items_attributes:,
    )
  end

  def filter_params
    params.permit(:status, :client_id)
  end

  def line_items_attributes
    [:description, :quantity, :unit_price, :total_price, :_destroy]
  end

  def set_select_options
    @categories = InvoiceCategory.all
    @clients = Client.all
  end
end
