# frozen_string_literal: true

module GoCardlessService
  class BankConnection
    ACCESS_TOKEN_CACHE_KEY = 'gocardless_access_token'
    TOKEN_EXPIRY = 23.hours # Set to 23 hours to be safe (actual token life is 24h)
    REFRESH_TOKEN_CACHE_KEY = 'gocardless_refresh_token'

    def initialize
      @client = Nordigen::NordigenClient.new(
        secret_id: ENV['GO_CARDLESS_SECRET_ID'],
        secret_key: ENV['GO_CARDLESS_SECRET_KEY'],
      )
      ensure_token
    end

    def init_bank_session(institution_id, user_id, user_language)
      @client.init_session(
        redirect_url: callback_url,
        institution_id: institution_id,
        reference_id: user_id,
        user_language: user_language,
        account_selection: false,
      )
    rescue StandardError => e
      Rails.logger.error("Failed to initialize bank session: #{e.message}")
      raise GoCardlessError, 'Failed to initialize bank session'
    end

    def banks(country = 'DE')
      @client.institution.get_institutions(country)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch #{country} banks: #{e.message}")
      raise BankConnectionError, 'Failed to fetch banks'
    end

    private

    def ensure_token
      @client.set_token(token)
    end

    def callback_url
      if Rails.env.development?
        'http://localhost:3000/bank_connections/callback'
      else
        Rails.application.routes.url_helpers.bank_connections_callback_url
      end
    end

    def connection_expired?(error)
      error.message.include?('consent expired')
    end

    def token
      GoCardlessService::Token.call
    end

    class BankConnectionError < StandardError; end
  end
end
