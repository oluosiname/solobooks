# frozen_string_literal: true

class InvoiceValidator::DatesValidator < ActiveModel::Validator
  def validate(record)
    return if record.date.blank? || record.due_date.blank?

    if record.due_date < record.date
      record.errors.add :due_date, 'must be after the date'
    end

    if record.due_date < Date.current
      record.errors.add :due_date, 'cannot be in the past'
    end
  end
end
