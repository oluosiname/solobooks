# frozen_string_literal: true

class VatStatus < ApplicationRecord
  belongs_to :user

  enum declaration_period: { monthly: 'monthly', quarterly: 'quarterly', annually: 'annually' }

  validates :starts_on, presence: true, if: -> { vat_registered? }
  validates :vat_number, presence: true, if: -> { vat_registered? }
  validates :declaration_period, presence: true, if: -> { vat_registered? }

  validates :tax_exempt_reason, presence: true, unless: -> { vat_registered? }
  validates :kleinunternehmer, inclusion: { in: [true, false] }, if: -> { tax_exempt_reason.present? }

  def charges_vat?
    vat_registered? && !kleinunternehmer?
  end
end
