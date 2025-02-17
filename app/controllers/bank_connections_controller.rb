# frozen_string_literal: true

class BankConnectionsController < ApplicationController
  def index
    @bank_connections = current_user.bank_connections
  end

  def new
    @bank_connection = current_user.bank_connections.new
    @banks = BankConnection.banks
  end

  def create
    result = bank_service.init_bank_session(
      params[:bank_connection][:institution_id],
      current_user.id.to_s + SecureRandom.hex(4),
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
      current_user.bank_connections.create!(
        requisition_id: session[:bank_requisition_id],
        institution_id: account['institution_id'],
        account_id: account_id,
        status: 'active',
        connection_service: 'gocardless',
        bank_name: BankConnection.bank_name(account['institution_id']),
      )
    end

    session.delete(:bank_requisition_id)

    redirect_to bank_connections_path,
      notice: I18n.t('record.create.success', resource: BankConnection.model_name.human)
  rescue => e
    redirect_to root_path, alert: e.message
  end

  private

  def bank_service
    @bank_service ||= GoCardlessService::BankConnection.new
  end
end
