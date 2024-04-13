# frozen_string_literal: true

RSpec.shared_examples 'Financial Transaction' do |_parameter|
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:transaction_type) }
  end
end
