# frozen_string_literal: true

class InvoiceValidator::LineItemsValidator < ActiveModel::Validator
  def validate(record)
    unless record.line_items.size.positive?
      record.errors.add :base, 'Invoice must contain line items.'
    end
  end
end
