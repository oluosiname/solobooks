# frozen_string_literal: true

module ClientValidator
  class AddressValidator < ActiveModel::Validator
    def validate(record)
      if record.address.blank?
        record.errors.add :base, 'Client must have an address'
      end
    end
  end
end
