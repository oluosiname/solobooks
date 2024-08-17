# frozen_string_literal: true

class FinancialTransaction < ApplicationRecord
  self.inheritance_column = :transaction_type

  ACCEPTABLE_RECEIPT_FORMATS = ['image/jpeg', 'image/png', 'application/pdf'].freeze
  MAX_RECEIPT_SIZE = 1.megabyte

  belongs_to :user
  belongs_to :category,
    class_name: 'FinancialCategory',
    foreign_key: 'financial_category_id',
    optional: true,
    inverse_of: :financial_transactions

  validates :amount, presence: true
  validates :date, presence: true
  validates :transaction_type, presence: true

  has_one_attached :receipt

  # validate :acceptable_receipt

  validates :receipt,
    attached: true,
    content_type: ACCEPTABLE_RECEIPT_FORMATS,
    size: { less_than_or_equal_to: MAX_RECEIPT_SIZE },
    if: -> { receipt.attached? }

  def income?
    transaction_type == 'Income'
  end

  def expense?
    transaction_type == 'Expense'
  end

  # private

  # def acceptable_receipt
  #   return unless receipt.attached?

  #   local_errors = []
  #   local_errors << 'is too big' if receipt.blob.byte_size > MAX_RECEIPT_SIZE
  #   local_errors << 'must be a JPEG, PNG  or PDF' if ACCEPTABLE_RECEIPT_FORMATS.exclude?(receipt.content_type)

  #   return if local_errors.empty?

  #   local_errors.each do |error|
  #     errors.add(:receipt, error)
  #   end

  #   receipt.purge
  # end
end
