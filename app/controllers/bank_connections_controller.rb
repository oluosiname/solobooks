# frozen_string_literal: true

class BankConnectionsController < ApplicationController
  def index
    @bank_connections = current_user.bank_connections
  end

  def new
    @bank_connection = current_user.bank_connections.new
    @banks = Rails.cache.fetch('banks', expires_in: 24.hours) do
      bank_service.banks
    end
  end

  def create
    result = bank_service.init_bank_session(
      params[:bank_connection][:institution_id],
      current_user.id.to_s + SecureRandom.hex(4),
      I18n.locale,
    )

    session[:bank_requisition_id] = result['id']
    session[:bank_institution_id] = params[:bank_connection][:institution_id]

    redirect_to result['link'], allow_other_host: true
  rescue => e
    redirect_to new_bank_connection_path, alert: e.message
  end

  private

  def bank_service
    @bank_service ||= GoCardlessService::BankConnection.new
  end
end
