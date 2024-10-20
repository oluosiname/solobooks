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

  scope :filtered, ->(params) {
    by_transaction_type(params[:transaction_type])
      .by_date(params[:start_date], params[:end_date])
      .by_description(params[:description])
  }

  scope :by_transaction_type, ->(transaction_type) {
    where(transaction_type: transaction_type.capitalize) if transaction_type.present?
  }

  scope :by_date, ->(start_date, end_date) {
    where(date: start_date..end_date) if start_date.present? && end_date.present?
  }

  scope :by_description, ->(description) {
    where('LOWER(description) LIKE ?', "%#{description.downcase}%") if description.present?
  }

  before_save :calculate_vat

  def income?
    transaction_type == 'Income'
  end

  def expense?
    transaction_type == 'Expense'
  end

  private

  def calculate_vat
    return if vat_rate.blank? || amount.blank?

    self.vat_amount = amount * (vat_rate.to_f / (100 + vat_rate))
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
