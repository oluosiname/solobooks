# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:address).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
  end
end
