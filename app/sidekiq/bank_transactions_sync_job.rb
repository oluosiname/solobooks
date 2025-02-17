# frozen_string_literal: true

class BankTransactionsSyncJob
  include Sidekiq::Job

  def perform(connection_id)
    connection = BankConnection.find(connection_id)

    date_from = (connection.last_sync_at || 1.month.ago).strftime('%Y-%m-%d')
    date_to = 1.day.ago.strftime('%Y-%m-%d')

    BankConnectionService::TransactionsSyncer.call(connection:, date_from:, date_to:)
  rescue => e
    Rails.logger.error("Failed to sync transactions for connection #{connection_id}: #{e.message}")
    Sentry.capture_exception(e)
  end
end
