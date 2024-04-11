# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, optional: true

  validates :street_address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true

  def full_address
    [street_address, city.capitalize, state.capitalize, postal_code, country_name].compact.join(', ')
  end

  def country_name
    iso_country = ISO3166::Country[country]
    iso_country&.translations&.[](I18n.locale.to_s) || iso_country.name
  end
end
