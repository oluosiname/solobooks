# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:invoice_category) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_presence_of(:total_amount) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:client) }
    it { is_expected.to validate_presence_of(:invoice_number) }
  end
end
