class CheckExpiredBankConnectionsJob
  include Sidekiq::Job

  def perform
    BankConnection.where('expires_at < ?', Time.current).find_each do |connection|
      connection.expired!
    end
  end
end
