# frozen_string_literal: true

class VatStatus < ApplicationRecord
  belongs_to :user

  validates :vat_registered, inclusion: { in: [true, false] }

  enum declaration_period: { monthly: 'monthly', quarterly: 'quarterly', annually: 'annually' }
end
