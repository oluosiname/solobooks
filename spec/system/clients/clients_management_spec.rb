# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Client Creation', type: :system do
  let(:user) { create(:user, :ready, :confirmed) }

  before { login_user(user) }

  describe 'viewing clients' do
    let!(:client) { create(:client, user:) }

    it 'shows clients' do
      visit clients_path

      expect(page).to have_content(client.display_name)
    end
  end

  describe 'delete client' do
    context 'when client has no invoices' do
      let!(:client) { create(:client, user: user) }

      it 'deletes client', :js do
        visit clients_path

        expect(page).to have_content(client.display_name)

        # accept_confirm do
        #   click_on 'Delete'
        # end
        find('.fa-solid.fa-ellipsis-vertical').click

        within('.dropdown-body') do
          click_on 'Delete'
        end

        expect(page).to have_content('Client was successfully deleted.')
        expect(page).to have_no_content(client.display_name)
      end
    end

    context 'when client has invoices' do
      it 'does not delete client', :js do
        client = create(:client, user: user)
        create(:invoice, user: user, client: client)

        visit clients_path

        expect(page).to have_content(client.display_name)

        find('.fa-solid.fa-ellipsis-vertical').click

        within('.dropdown-body') do
          click_on 'Delete'
        end

        expect(page).to have_content('Cannot delete client because it has invoices associated with it')
        expect(page).to have_content(client.display_name)
      end
    end
  end
end
