# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates :full_name, presence: true
  validates :phone_number, presence: true
  validates :date_of_birth, presence: true
end