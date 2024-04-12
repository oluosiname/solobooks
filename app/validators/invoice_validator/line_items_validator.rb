# frozen_string_literal: true

module InvoiceValidator
  class LineItemsValidator < ActiveModel::Validator
    def validate(record)
      unless record.line_items.size.positive?
        record.errors.add :base, I18n.t('activerecord.errors.models.invoice.attributes.line_items.blank')
      end
    end
  end
end
