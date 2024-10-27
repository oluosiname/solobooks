# frozen_string_literal: true

class TinkController < ApplicationController
  TINK_BASE_URL = 'https://api.tink.com/api/v1'
  TINK_OAUTH_URL = Rails.env.production? ? 'https://oauth.tink.com/authorize' : 'https://oauth.tink.com/sandbox/authorize'

  def connect
    redirect_to 'https://oauth.tink.com/0.4/authorize/?' + {
      client_id: ENV['TINK_CLIENT_ID'],
      redirect_uri: ENV['TINK_REDIRECT_URI'],
      scope: 'accounts:read,transactions:read',
      response_type: 'code',
      market: 'DE',
    }.to_query,
      allow_other_host: true
  end

  def callback
    code = params[:code]
    uri = URI.parse('https://api.tink.com/api/v1/oauth/token')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      'client_id' => ENV['TINK_CLIENT_ID'],
      'client_secret' => ENV['TINK_CLIENT_SECRET'],
      'code' => code,
      'grant_type' => 'authorization_code',
      'redirect_uri' => ENV['TINK_REDIRECT_URI'],
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      token_data = JSON.parse(response.body.to_s)
      user_token = UserToken.find_or_initialize_by(user_id: current_user.id, service: 'tink')
      user_token.access_token = token_data['access_token']
      user_token.refresh_token = token_data['refresh_token']
      user_token.expires_at = Time.zone.now + token_data['expires_in'].to_i.seconds
      user_token.save
      redirect_to transactions_path, notice: I18n.t('tink.auth.success')
    else
      error_message = token_data['errorMessage'] || I18n.t('tink.auth.error')
      redirect_to root_path, alert: error_message
    end

    redirect_to transactions_path
  end

  
end
