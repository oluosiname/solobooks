# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  it_behaves_like 'Financial Transaction'
end
