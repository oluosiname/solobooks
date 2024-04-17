# frozen_string_literal: true

module NokoService
  class EntriesFetcher < ApplicationService
    def initialize(from:, to:)
      @from = from.strftime('%Y-%m-%d')
      @to = to.strftime('%Y-%m-%d')
    end

    def call
      noko.get_entries(from: from, to: to)
    end

    private

    attr_reader :from, :to

    def noko
      @noko ||= Noko::Client.new(token: ENV.fetch('NOKO_TOKEN'))
    end
  end
end
