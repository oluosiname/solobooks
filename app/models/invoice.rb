# frozen_string_literal: true

class Invoice < ApplicationRecord
  include AASM

  belongs_to :invoice_category
  belongs_to :user
  belongs_to :client
  has_many :line_items, dependent: :destroy
  belongs_to :currency

  validates :date, presence: true
  validates :due_date, presence: true
  validates :total_amount, presence: true
  validates_with InvoiceValidator::LineItemsValidator
  validates_with InvoiceValidator::DatesValidator

  validates :invoice_number, uniqueness: { scope: :user_id }

  before_validation :set_total_amount

  before_create :set_invoice_number

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: :all_blank

  has_one_attached :pdf

  scope :created_in_current_month, -> {
    where(created_at: Time.zone.now.all_month)
  }

  scope :filtered, ->(params) {
    return unless params

    filter_by_status(params[:status]).filter_by_client(params[:client_id])
  }

  scope :filter_by_status, ->(status) { where(status: status) if status.present? }
  scope :filter_by_client, ->(client_id) { where(client_id: client_id) if client_id.present? }

  VAT_RATES = {
    '0%' => 0,
    '7%' => 7,
    '19%' => 19,
    '20%' => 20,
  }

  LANGUAGES = {
    'English' => 'en',
    'Deutsch' => 'de',
  }

  enum vat_technique: {
         standard: 'standard',
         reverse_charge: 'reverse_charge',
         exempt: 'exempt',
         non_eu: 'non_eu',
         none: 'none',
       },
    _prefix: :vat

  enum status: {
    draft: 'draft',
    sent: 'sent',
    paid: 'paid',
    cancelled: 'cancelled',
    overdue: 'overdue',
  }

  aasm column: 'status' do
    state :draft
    state :sent
    state :paid
    state :cancelled
    state :overdue

    event :send_invoice do
      transitions from: :draft, to: :sent
    end

    event :pay do
      transitions from: [:sent, :draft, :overdue], to: :paid
    end

    event :cancel do
      transitions from: [:draft, :sent, :overdue], to: :cancelled
    end

    event :mark_overdue do
      transitions from: :sent, to: :overdue
    end

    event :send_reminder do
      transitions from: :overdue, to: :sent
    end
  end

  def client_name
    client.display_name
  end

  def currency_symbol
    currency&.symbol || Currency.default_currency.symbol
  end

  def update_total_amount
    set_total_amount
    save
  end

  def set_invoice_number
    self.invoice_number = generate_invoice_number
  end

  private

  def set_total_amount
    initial_total_amount = line_items.sum(&:total_price)

    self.total_amount = if vat_included
      initial_total_amount
    else
      initial_total_amount * (1.0 + (vat_rate.to_f / 100.0))
    end

    self.subtotal = total_amount / (1 + (vat_rate / 100))

    self.vat = total_amount - subtotal
  end

  def generate_invoice_number
    suffix = user.invoices.created_in_current_month.size + 1
    month = Time.zone.today.month.to_s.rjust(2, '0')
    suffix = suffix.to_s.rjust(2, '0')
    self.invoice_number = "INV-#{Time.zone.today.year}-#{month}-#{suffix}"
  end
end
