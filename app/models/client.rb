# frozen_string_literal: true

class Client < ApplicationRecord
  has_one :address, as: :addressable
  has_many :addresses

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank
end
