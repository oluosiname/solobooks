# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VatStatus, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:vat_registered).in_array([true, false]) }

    context 'when VAT is registered' do
      subject { build(:vat_status, vat_registered: true, user: user) }

      it { is_expected.to validate_presence_of(:starts_on) }
      it { is_expected.to validate_presence_of(:vat_number) }
      it { is_expected.to validate_presence_of(:declaration_period) }
      it { is_expected.not_to validate_presence_of(:tax_exempt_reason) }
    end

    context 'when VAT is not registered' do
      subject { build(:vat_status, vat_registered: false, user: user) }

      it { is_expected.to validate_presence_of(:tax_exempt_reason) }
      it { is_expected.to validate_inclusion_of(:kleinunternehmer).in_array([true, false]) }
    end
  end

  describe '#charges_vat?' do
    subject { vat_status.charges_vat? }

    let(:vat_status) { build(:vat_status, vat_registered:, kleinunternehmer:) }
    let(:kleinunternehmer) { false }
    let(:vat_registered) { true }

    context 'when VAT is not registered' do
      let(:vat_registered) { false }

      it { is_expected.to be(false) }
    end

    context 'when VAT is registered' do
      let(:vat_registered) { true }

      it { is_expected.to be(true) }
    end

    context 'when VAT is registered but user is a Kleinunternehmer' do
      let(:kleinunternehmer) { true }
      let(:vat_registered) { true }

      it { is_expected.to be(false) }
    end

    context 'when VAT is not registered and user is a Kleinunternehmer' do
      let(:kleinunternehmer) { true }
      let(:vat_registered) { false }

      it { is_expected.to be(false) }
    end

    context 'when VAT is not registered and user is not a Kleinunternehmer' do
      let(:kleinunternehmer) { false }
      let(:vat_registered) { false }

      it { is_expected.to be(true) }
    end
  end
end
