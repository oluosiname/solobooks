# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :invoice_currency, class_name: 'Currency'
  has_one :setting, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates :full_name, presence: true
  validates :phone_number, presence: true
  validates :date_of_birth, presence: true

  def complete?
    (full_name.present? || business_name.present?) && address.present?
  end

  def vat_exempted?
    vat_id.blank?
  end
end
