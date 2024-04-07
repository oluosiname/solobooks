# frozen_string_literal: true

class ClientValidator::AddressValidator < ActiveModel::Validator
  def validate(record)
    unless record.address.present?
      record.errors.add :base, 'Client must have an address'
    end
  end
end
