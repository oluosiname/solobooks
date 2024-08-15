# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :set_select_options, only: [:new, :create]
  before_action :set_invoice, only: [:send_invoice, :pay, :cancel, :mark_overdue]

  include Pagy::Backend

  def index
    @pagy, @invoices = pagy(current_user
      .invoices
      .filtered(filter_params)
      .includes(:client, :currency, :pdf_attachment)
      .order(created_at: :desc))

    respond_to do |format|
      format.html # For normal HTML requests
      format.turbo_stream # For Turbo Stream requests
    end
  end

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

      redirect_to invoices_path,
        notice: I18n.t('record.create.success', resource: @invoice.class.model_name.human),
        turbo: false,
        turbo_stream: false
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

  def send_invoice
    if @invoice.may_send_invoice?
      @invoice.send_invoice!
      redirect_back fallback_location: invoices_path, notice: I18n.t('invoices_controller.send_invoice.success')
    else
      redirect_back fallback_location: invoices_path, alert: I18n.t('invoices_controller.send_invoice.failure')
    end
  end

  def pay
    if @invoice.may_pay?
      @invoice.pay!
      redirect_back fallback_location: invoices_path, notice: I18n.t('invoices_controller.pay.success')
    else
      redirect_back fallback_location: invoices_path, alert: I18n.t('invoices_controller.pay.failure')
    end
  end

  def cancel
    if @invoice.may_cancel?
      @invoice.cancel!
      redirect_back fallback_location: invoices_path, notice: I18n.t('invoices_controller.cancel.success')
    else
      redirect_back fallback_location: invoices_path, alert: I18n.t('invoices_controller.cancel.failure')
    end
  end

  def mark_overdue
    if @invoice.may_mark_overdue?
      @invoice.mark_overdue!
      redirect_back fallback_location: invoices_path, notice: I18n.t('invoices_controller.mark_overdue.success')
    else
      redirect_back fallback_location: invoices_path, alert: I18n.t('invoices_controller.mark_overdue.failure')
    end
  end

  def send_reminder
    if @invoice.may_send_reminder?
      @invoice.send_reminder!
      redirect_back fallback_location: invoices_path, notice: I18n.t('invoices_controller.send_reminder.success')
    else
      redirect_back fallback_location: invoices_path, alert: I18n.t('invoices_controller.send_reminder.failure')
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

  def vat_technique_params
    client_id = params[:invoice][:client_id]
    client = current_user.clients.find(client_id)
    vat_strategy = client.vat_strategy

    { vat_technique: vat_strategy }
  end

  def filter_params
    params.permit(:status, :client_id, :start_date, :end_date, :query)
  end

  def line_items_attributes
    [:description, :quantity, :unit, :unit_price, :total_price, :_destroy]
  end

  def set_select_options
    @categories = InvoiceCategory.all
    @clients = current_user.clients
  end

  def set_invoice
    @invoice = current_user.invoices.find(params[:id])
  end
end
