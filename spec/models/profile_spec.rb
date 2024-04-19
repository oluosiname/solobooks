# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to belong_to(:currency) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
  end

  describe '#complete?' do
    context 'when all required attributes are present' do
      let(:profile) do
        build(
          :profile,
          full_name: 'John Doe',
          phone_number: '1234567890',
          date_of_birth: Time.zone.today,
          address: build(:address),
        )
      end

      it 'returns true' do
        expect(profile.complete?).to be true
      end
    end

    context 'when any required attribute is missing' do
      let(:profile) { build(:profile, full_name: nil, business_name: nil) }

      it 'returns false' do
        expect(profile.complete?).to be false
      end
    end
  end
end
