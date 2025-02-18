# frozen_string_literal: true

class BankConnection < ApplicationRecord
  belongs_to :user

  validates :account_number, presence: true, uniqueness: true
  validates :institution_id, presence: true
  validates :account_id, presence: true

  scope :needs_sync, -> {
    active
      .where('last_sync_at < ? OR last_sync_at IS NULL', 24.hours.ago)
      .where(sync_enabled: true)
  }

  after_create :sync

  after_create_commit :clean_up_deleted_accounts

  enum status: {
    active: 'active',
    inactive: 'inactive',
    error: 'error',
    expired: 'expired',
    disconnected: 'disconnected',
  }

  enum connection_service: {
    gocardless: 'gocardless',
  }

  class << self
    def banks(country = 'DE')
      Rails.cache.fetch("bank_institutions_#{country}", expires_in: 7.days) do
        bank_service = GoCardlessService::BankConnection.new
        bank_service.banks(country)
      end
    end

    def bank_name(institution_id)
      bank = banks.find { |bank| bank['id'] == institution_id }
      bank['name'] if bank
    end

    def bank_logos(country = 'DE')
      result = {}
      banks.each do |bank|
        result[bank['id']] = bank['logo']
      end

      result
    end
  end

  private

  def sync
    BankTransactionsSyncJob.perform_async(id)
  end

  def clean_up_deleted_accounts
    BankConnectionDeletedAccountCleanUpJob.perform_async(id)
  end
end
