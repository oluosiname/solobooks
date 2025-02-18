# frozen_string_literal: true

module BankConnectionService
  class TransactionsSyncer < ApplicationService
    def initialize(connection:, date_from:, date_to:)
      @connection = connection
      @date_from = date_from
      @date_to = date_to
    end

    def call
      result = bank_service.transactions(
        connection.account_id,
        date_from,
        date_to,
      )

      raise TransactionsSyncerError, result['detail'] unless result && result['transactions']

      transactions = result['transactions']['booked']

      store_transactions(connection.user, transactions)

      connection.update!(last_sync_at: Time.current)
    rescue => e
      connection.update!(status: :error)
      Rails.logger.error("Failed to sync transactions for connection_id #{connection.id}: #{e.message}")
      Sentry.capture_exception(e)
    end

    private

    attr_reader :connection, :date_from, :date_to

    def bank_service
      @bank_service ||= GoCardlessService::BankConnection.new
    end

    def store_transactions(transactions)
      connection.user.synced_transactions.create!(transactions.map { |t| transaction_params(t) })
    end

    def transaction_params(transaction)
      {
        amount: transaction['transactionAmount']['amount'],
        currency: transaction['transactionAmount']['currency'],
        description: transaction['remittanceInformationUnstructured'],
        booked_at: transaction['bookingDate'],
        transaction_id: transaction['transactionId'],
        creditor_name: transaction['creditorName'],
      }
    end
  end

  class TransactionsSyncerError < StandardError; end
end

