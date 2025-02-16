# frozen_string_literal: true

class BankConnection < ApplicationRecord
  belongs_to :user

  validates :requisition_id, presence: true, uniqueness: true
  validates :institution_id, presence: true
  validates :account_id, presence: true

  enum status: {
    pending: 'pending',
    active: 'active',
    inactive: 'inactive',
    error: 'error',
  }

  enum connection_service: {
    gocardless: 'gocardless',
  }
end
