# frozen_string_literal: true

class BankConnection < ApplicationRecord
  belongs_to :user

  validates :requisition_id, presence: true, uniqueness: true
  validates :institution_id, presence: true
  validates :account_id, presence: true

  after_create :sync

  after_create_commit :clean_up_deleted_accounts

  enum status: {
    active: 'active',
    inactive: 'inactive',
    error: 'error',
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
  end

  private

  def sync
    BankTransactionsSyncJob.perform_async(id)
  end

  def clean_up_deleted_accounts
    BankConnectionEnrichJob.perform_async(id)
  end
end
