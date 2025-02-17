# frozen_string_literal: true

class SyncedTransaction < ApplicationRecord
  belongs_to :user

  enum status: {
    pending: 'pending',
    approved: 'approved',
    declined: 'declined',
  }
end
