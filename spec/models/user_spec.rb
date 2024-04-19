# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:invoices).dependent(:destroy) }
    it { is_expected.to have_many(:clients).dependent(:destroy) }
    it { is_expected.to have_one(:profile).dependent(:destroy) }
    it { is_expected.to have_one(:payment_detail).dependent(:destroy) }
    it { is_expected.to have_many(:expenses).dependent(:destroy) }
    it { is_expected.to have_many(:incomes).dependent(:destroy) }
    it { is_expected.to have_many(:financial_transactions).dependent(:destroy) }
  end

  describe 'devise modules' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    # add more tests for devise modules if needed
  end

  describe '#can_create_invoice?' do
    context 'when user has a complete profile and payment detail' do
      let(:user) { create(:user, profile: create(:profile), payment_detail: create(:payment_detail)) }

      it 'returns true' do
        expect(user.can_create_invoice?).to be true
      end
    end

    context 'when user has no profile' do
      let(:user) { create(:user, profile: nil, payment_detail: create(:payment_detail)) }

      it 'returns false' do
        expect(user.can_create_invoice?).to be false
      end
    end

    context "when user's profile is incomplete" do
      let(:user) { create(:user, payment_detail: create(:payment_detail)) }

      before do
        allow(user.profile).to receive(:complete?).and_return(false)
      end

      it 'returns false' do
        expect(user.can_create_invoice?).to be false
      end
    end

    context 'when user has no payment detail' do
      let(:user) { create(:user, profile: create(:profile), payment_detail: nil) }

      it 'returns false' do
        expect(user.can_create_invoice?).to be false
      end
    end
  end
end
