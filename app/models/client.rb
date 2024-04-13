# frozen_string_literal: true

class Client < ApplicationRecord
  has_one :address, as: :addressable, dependent: :destroy
  validate :name_xor_business_name
  validates :email, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user
  has_many :invoices, dependent: :restrict_with_error
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates_with ClientValidator::AddressValidator

  validates :name, presence: true, if: -> { business_name.blank? }
  validates :business_name, presence: true, if: -> { name.blank? }

  validates :name, uniqueness: { scope: :user_id }, if: -> { name.present? }
  validates :business_name, uniqueness: { scope: :user_id }, if: -> { business_name.present? }

  def display_name
    business_name.presence || name
  end

  def full_address
    address&.full_address
  end

  private

  def name_xor_business_name
    if name.blank? && business_name.blank?
      errors.add(:base, 'Name or Business Name must be present')
    end
  end
end
