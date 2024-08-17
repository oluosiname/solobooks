# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  let(:user) { create(:user, :ready) }
  let!(:transaction) { create(:income, user:, amount: 50) }

  before { login_user(user) }

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the transaction and redirects to transactions index' do
        patch transaction_path(transaction), params: { income: { amount: 100 } }
        expect(response).to redirect_to(transactions_path)
        follow_redirect!
        expect(response.body).to include(I18n.t(
          'record.update.success',
          resource: transaction.model_name.human,
        ))
        transaction.reload
        expect(transaction.amount).to eq(100)
      end
    end

    context 'with invalid params' do
      it 'renders the edit template with unprocessable_entity status' do
        patch transaction_path(transaction), params: { income: { amount: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
