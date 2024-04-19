# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:user) { create(:user) }
  let(:client) { build(:client, user: user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:invoices).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    subject { client }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:user_id) }

    it 'validates presence of name or business_name' do
      client.name = nil
      client.business_name = nil
      expect(client).not_to be_valid
      expect(client.errors[:base]).to include('Name or Business Name must be present')
    end
  end

  describe '#display_name' do
    context 'when both name and business_name are present' do
      let(:client) { build(:client, user: user, name: 'John', business_name: 'ABC Inc.') }

      it 'returns the business_name' do
        expect(client.display_name).to eq('ABC Inc.')
      end
    end

    context 'when only name is present' do
      let(:client) { build(:client, user: user, name: 'John', business_name: nil) }

      it 'returns the name' do
        expect(client.display_name).to eq('John')
      end
    end

    context 'when only business_name is present' do
      let(:client) { build(:client, user: user, name: nil, business_name: 'ABC Inc.') }

      it 'returns the business_name' do
        expect(client.display_name).to eq('ABC Inc.')
      end
    end
  end

  describe '#vat_strategy' do
    let(:user) { create(:user, profile: profile) }
    let(:client) { build(:client, user: user) }
    let(:profile) { build(:profile, country: user_country) }
    let(:user_country) { 'DE' }
    let(:client_country) { 'DE' }

    before do
      allow(client).to receive(:country).and_return(client_country)
    end

    context 'when user profile is VAT exempted' do
      before do
        allow(user.profile).to receive(:vat_exempted?).and_return(true)
      end

      it 'returns VAT_TECHNIQUES[:none]' do
        expect(client.vat_strategy).to eq(Invoice::VAT_TECHNIQUES[:none])
      end
    end

    context 'when client country is outside EU' do
      let(:client_country) { 'US' }

      it 'returns VAT_TECHNIQUES[:none]' do
        expect(client.vat_strategy).to eq(Invoice::VAT_TECHNIQUES[:non_eu])
      end
    end

    context 'when client country is in EU but different from user country' do
      let(:client_country) { 'FR' }

      it 'returns VAT_TECHNIQUES[:reverse_charge]' do
        expect(client.vat_strategy).to eq(Invoice::VAT_TECHNIQUES[:reverse_charge])
      end
    end

    context 'when client country is in EU and same as user country' do
      let(:client_country) { 'DE' }

      it 'returns VAT_TECHNIQUES[:standard]' do
        expect(client.vat_strategy).to eq(Invoice::VAT_TECHNIQUES[:standard])
      end
    end
  end
end

# let(:invoice) { create(:invoice, user: create(:user, :ready)) }
#     let(:client_country_code) { 'DE' } # Germany
#     let(:user_country_code) { 'DE' } # United States

#     context 'when the user is VAT exempted' do
#       before { allow(invoice.user.profile).to receive(:vat_exempted?).and_return(true) }

#       it "returns 'None'" do
#         expect(invoice.vat_technique(client_country_code, user_country_code)).to eq(Invoice::VAT_TECHNIQUES[:none])
#       end
#     end

#     context 'when the client country is not in EU VAT zone' do
#       let(:client_country_code) { 'US' }

#       it "returns 'Non-EU'" do
#         expect(invoice.vat_technique(client_country_code, user_country_code)).to eq(Invoice::VAT_TECHNIQUES[:non_eu])
#       end
#     end

#     context 'when the client country is in EU VAT zone' do
#       context 'when the client and user countries are the same' do
#         it "returns 'Standard'" do
#           expect(invoice.vat_technique(
#             client_country_code,
#             client_country_code,
#           )).to eq(Invoice::VAT_TECHNIQUES[:standard])
#         end
#       end

#       context 'when the client and user countries are different' do
#         let(:client_country_code) { 'FR' }

#         it "returns 'Reverse Charge'" do
#           expect(invoice.vat_technique(
#             client_country_code,
#             user_country_code,
#           )).to eq(Invoice::VAT_TECHNIQUES[:reverse_charge])
#         end
#       end
#     end
