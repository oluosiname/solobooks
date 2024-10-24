# frozen_string_literal: true

module InvoiceValidator
  class DatesValidator < ActiveModel::Validator
    def validate(record)
      return if record.date.blank? || record.due_date.blank? || !record.new_record?

      if record.due_date < record.date
        record.errors.add :due_date, 'must be after the date'
      end

      if record.due_date < Date.current
        record.errors.add :due_date, 'cannot be in the past'
      end
    end
  end
end
