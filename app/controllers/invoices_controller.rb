# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :set_select_options, only: [:new, :create]

  def index
    @invoices = current_user
      .invoices
      .filtered(filter_params)
      .includes(:client, :currency, :pdf_attachment)
      .order(created_at: :desc)
  end

  # def show
  #   @invoice = current_user.invoices.includes(:client, :currency, :line_items).find(params[:id])

  #   prev_locale = I18n.locale
  #   # I18n.locale = @invoice.language.to_sym
  #   I18n.locale = :en
  #   pdf = InvoiceService::PdfGenerator.call(invoice: @invoice)
  #   I18n.locale = prev_locale
  #   send_data(
  #     pdf.render,
  #     file_name: "Invoice - #{@invoice.invoice_number}",
  #     type: 'application/pdf',
  #     disposition: 'inline',
  #   )
  # end

  def new
    unless current_user.can_create_invoice?
      return redirect_to invoices_path, warning: I18n.t('invoices.new.profile_missing')
    end

    @invoice = Invoice.new
    @invoice.line_items.build
  end

  def create
    @invoice = Invoice.new(invoice_params.merge(user: current_user, **vat_technique_params))
    if @invoice.save

      prev_locale = I18n.locale
      I18n.locale = @invoice.language.to_sym
      pdf_file = InvoiceService::PdfGenerator.call(invoice: @invoice)
      I18n.locale = prev_locale

      InvoiceService::PdfAttacher.call(invoice: @invoice, pdf: StringIO.new(pdf_file.render))

      redirect_to invoices_path, notice: I18n.t('record.create.success', resource: @invoice.class.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def vat_technique
    client_id = params[:client_id]
    client = current_user.clients.find(client_id)
    vat_strategy = client.vat_strategy

    render json: {
      vat_technique: vat_strategy,
      message: I18n.t("activerecord.attributes.invoice.vat_techniques.#{vat_strategy}"),
    }.to_json
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

  def vat_technique_params
    client_id = params[:invoice][:client_id]
    client = current_user.clients.find(client_id)
    vat_strategy = client.vat_strategy

    { vat_technique: vat_strategy }
  end

  def filter_params
    params.permit(:status, :client_id)
  end

  def line_items_attributes
    [:description, :quantity, :unit, :unit_price, :total_price, :_destroy]
  end

  def set_select_options
    @categories = InvoiceCategory.all
    @clients = current_user.clients
  end
end
