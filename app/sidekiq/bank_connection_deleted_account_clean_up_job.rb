class BankConnectionDeletedAccountCleanUpJob
  include Sidekiq::Job

  def perform(bank_connection_id)
    @connection = BankConnection.find(bank_connection_id)

    connection.destroy if account['status'] == 'deleted'
  end

  private

  attr_reader :connection

  def account
    @account ||= bank_service.account(connection.account_id)
  end

  def bank_service
    @bank_service ||= GoCardlessService::BankConnection.new
  end
end
