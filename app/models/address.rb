# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true

  def full_address
    [street_address, city.capitalize, state.capitalize, postal_code, country].compact.join(', ')
  end
end
