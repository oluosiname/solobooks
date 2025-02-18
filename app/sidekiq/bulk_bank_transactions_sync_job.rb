# frozen_string_literal: true

class BulkBankTransactionsSyncJob
  include Sidekiq::Job

  def perform(*args)
    BankConnection.needs_sync.find_each do |connection|
      BankConnectionService::TransactionSyncer.call(connection:)
    rescue => e
      Rails.logger.error("Failed to sync transactions for connection #{connection.id}: #{e.message}")
    end
  end
end
