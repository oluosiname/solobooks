# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank
end
