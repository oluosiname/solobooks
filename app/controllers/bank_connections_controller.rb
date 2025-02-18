# frozen_string_literal: true

class BankConnectionsController < ApplicationController
  before_action :set_bank_connection, only: [:toggle]

  def index
    @bank_connections = current_user.bank_connections

    @bank_logos = BankConnection.bank_logos
  end

  def new
    @bank_connection = current_user.bank_connections.new
    @banks = BankConnection.banks
  end

  def create
    result = bank_service.init_bank_session(
      params[:bank_connection][:institution_id],
      current_user.id.to_s + '_' + SecureRandom.hex(4),
      I18n.locale,
    )

    session[:bank_requisition_id] = result['id']

    redirect_to result['link'], allow_other_host: true
  rescue => e
    redirect_to new_bank_connection_path, alert: e.message
  end

  def callback
    accounts = bank_service.accounts(session[:bank_requisition_id])

    accounts.each do |account|
      connection = current_user.bank_connections.find_or_initialize_by(account_id: account['id'])
      connection&.update!(
        status: 'active',
        expires_at: 90.days.from_now,
        status: 'active',
        sync_enabled: true,
        account_number: account['iban'],
        bank_name: BankConnection.bank_name(account['institution_id']),
        connection_service: 'gocardless',
        institution_id: account['institution_id'],
      )
    rescue => e
      Rails.logger.error("Failed to create bank connection: #{e.message}")
      Sentry.capture_exception(e)
    end

    session.delete(:bank_requisition_id)

    redirect_to bank_connections_path,
      notice: I18n.t('record.create.success', resource: BankConnection.model_name.human)
  rescue => e
    redirect_to root_path, alert: e.message
  end

  def toggle
    @bank_connection.update(sync_enabled: !@bank_connection.sync_enabled)
    @bank_logos = BankConnection.bank_logos

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "bank-connection-#{@bank_connection.id}",
          partial: 'bank_connections/bank_connection',
          locals: { bank_connection: @bank_connection },
        )
      end
      format.html { redirect_to bank_connections_path, notice: t('bank_connections.updated') }
    end
  end

  def sync
    @bank_connection = BankConnection.find(params[:id])

    BankTransactionsSyncJob.perform_async(@bank_connection.id)

    respond_to do |format|
      format.html do
        redirect_back(fallback_location: bank_connections_path, notice: t('bank_connections.syncing'))
      end
      format.turbo_stream do
        flash.now[:notice] = t('bank_connections.syncing')
      end
    end
  end

  private

  def bank_service
    @bank_service ||= GoCardlessService::BankConnection.new
  end

  def set_bank_connection
    @bank_connection = BankConnection.find(params[:id])
  end
end
