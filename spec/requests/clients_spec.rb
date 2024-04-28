# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients', type: :request do
  describe 'DELETE /clients/:id' do
    let(:user) { create(:user, :confirmed) }
    let(:client) { create(:client, user: user) }

    before { login_user(user) }

    context 'when destroy is successful' do
      it 'destroys the client' do
        delete client_path(client)
        expect(response).to redirect_to(clients_url)
        follow_redirect!
        expect(response.body).to include(I18n.t('record.destroy.success', resource: Client.model_name.human))
        expect(Client).not_to exist(client.id)
      end
    end

    context 'when destroy fails' do
      before { create(:invoice, client:) }

      it 'does not destroy the client' do
        delete client_path(client)
        expect(response).to redirect_to(clients_url)
        follow_redirect!
        expect(response.body).to include(I18n.t('record.destroy.error', resource: Client.model_name.human))
        expect(response.body).to include('Cannot delete client because it has invoices associated with it')
        expect(Client).to exist(client.id)
      end
    end
  end
end
