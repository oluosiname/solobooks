# frozen_string_literal: true

class Profile < ApplicationRecord
  ACCEPTABLE_LOGO_FORMATS = ['image/jpeg', 'image/png'].freeze
  MAX_LOGO_SIZE = 1.megabyte

  encrypts :vat_id, :tax_number

  belongs_to :user
  belongs_to :invoice_currency, class_name: 'Currency'
  has_one :setting, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  has_one_attached :logo

  validates :full_name, presence: true
  validates :phone_number, presence: true
  validates :date_of_birth, presence: true

  validates :logo,
    attached: true,
    content_type: ACCEPTABLE_LOGO_FORMATS,
    size: { less_than_or_equal_to: MAX_LOGO_SIZE },
    if: -> { logo.attached? }

  enum legal_status: { individual: 'individual', business: 'business' }

  def complete?
    (full_name.present? || business_name.present?) && address.present?
  end

  def vat_exempted?
    vat_id.blank?
  end

  def name
    business_name.presence || full_name
  end
end
