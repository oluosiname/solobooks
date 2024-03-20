# frozen_string_literal: true

class Client < ApplicationRecord
  has_one :address, as: :addressable
  validate :name_xor_business_name
  validates :email, presence: true, uniqueness: true
  belongs_to :user
  has_many :invoices
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates_with ClientValidator::AddressValidator

  private

  def name_xor_business_name
    if name.blank? && business_name.blank?
      errors.add(:base, 'Name or Business Name must be present')
    end
  end
end
