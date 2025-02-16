# frozen_string_literal: true

module GoCardlessService
  class Token < ApplicationService
    ACCESS_TOKEN_KEY = 'gocardless_access_token'
    REFRESH_TOKEN_KEY = 'gocardless_refresh_token'
    ACCESS_TOKEN_EXPIRY = 23.hours
    REFRESH_TOKEN_EXPIRY = 29.days # Actual is 30 days, being conservative

    def call
      access_token = Rails.cache.read(ACCESS_TOKEN_KEY)
      return access_token if access_token

      # If no access token, try to use refresh token
      if (refresh_token = Rails.cache.read(REFRESH_TOKEN_KEY))
        return refreshed_access_token(refresh_token)
      end

      # If no tokens at all, generate new ones
      generate_new_tokens
    end

    private

    def generate_new_tokens
      token_data = client.generate_token

      store_tokens(
        token_data['access'],
        token_data['refresh'],
      )

      token_data['access']
    end

    def refreshed_access_token(refresh_token)
      new_token_data = client.exchange_token(refresh_token)

      store_tokens(
        new_token_data['access'],
        new_token_data['refresh'],
      )

      new_token_data['access']
    rescue StandardError => e
      Rails.logger.error("Failed to refresh token: #{e.message}")
      # If refresh fails, generate new tokens
      generate_new_tokens
    end

    def store_tokens(access_token, refresh_token)
      Rails.cache.write(ACCESS_TOKEN_KEY, access_token, expires_in: ACCESS_TOKEN_EXPIRY)
      Rails.cache.write(REFRESH_TOKEN_KEY, refresh_token, expires_in: REFRESH_TOKEN_EXPIRY)
    end

    def client
      @client ||= Nordigen::NordigenClient.new(
        secret_id: ENV['GO_CARDLESS_SECRET_ID'],
        secret_key: ENV['GO_CARDLESS_SECRET_KEY'],
      )
    end
  end
end
