# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NokoService::EntriesFetcher do
  describe '#call' do
    let(:from_date) { Date.new(2024, 1, 1) }
    let(:to_date) { Date.new(2024, 1, 31) }
    let(:noko_client) { instance_double(Noko::Client) }
    let(:entries) { [{ id: 1, date: '2024-01-01', minutes: 480, project: 'Project A' }] }

    before do
      allow(Noko::Client).to receive(:new).and_return(noko_client)
      allow(noko_client).to receive(:get_entries).and_return(entries)
      allow(ENV).to receive(:fetch).with('NOKO_TOKEN').and_return('noko_token')
    end

    it 'calls get_entries on Noko::Client with correct arguments' do
      described_class.new(from: from_date, to: to_date).call
      expect(noko_client).to have_received(:get_entries).with(from: '2024-01-01', to: '2024-01-31')
    end

    it 'returns the entries fetched from Noko with minutes instead of hours' do
      fetched_entries = described_class.new(from: from_date, to: to_date).call
      expect(fetched_entries).to eq(entries)
    end

    context 'when Noko::Client raises an error' do
      before do
        allow(noko_client).to receive(:get_entries).and_raise(StandardError, 'Noko API error')
      end

      it 'raises an error' do
        expect do
          described_class.new(from: from_date, to: to_date).call
        end.to raise_error(StandardError, 'Noko API error')
      end
    end
  end
end
