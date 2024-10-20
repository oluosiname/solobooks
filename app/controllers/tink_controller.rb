# frozen_string_literal: true

class TinkController < ApplicationController
  TINK_BASE_URL = 'https://api.tink.com/api/v1'
  TINK_OAUTH_URL = Rails.env.production? ? 'https://oauth.tink.com/authorize' : 'https://oauth.tink.com/sandbox/authorize'

  def connect
    client_id = ENV['TINK_CLIENT_ID']
    redirect_uri = ENV['TINK_REDIRECT_URI']
    scope = 'accounts:read,transactions:read'
    response_type = 'code'
    state = SecureRandom.hex(10)

    # uri = URI(base_url)
    # uri.query = URI.encode_www_form({
    #   client_id: client_id,
    #   redirect_uri: redirect_uri,
    #   scope: scope,
    #   response_type: response_type,
    #   state: state,
    # })

    # redirect_to uri.to_s

    # tink_url = "#{TINK_OAUTH_URL}/?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&response_type=#{response_type}&state=#{state}"

    # redirect_to tink_url, allow_other_host: true
    uri = URI('https://oauth.tink.com/authorize')
    uri.query = URI.encode_www_form({
      client_id: 'c8f49a8b215f468caba6c92fddf66fee',
      redirect_uri: ENV['TINK_REDIRECT_URI'],
      scope: 'accounts:read,transactions:read',
      response_type: 'code',
      state: SecureRandom.hex(10),
    })

    redirect_to uri.to_s, allow_other_host: true
  end

  def callback
    if params[:code]
      response = HTTP.post('https://api.tink.com/api/v1/oauth/token', form: {
        code: params[:code],
        client_id: ENV['TINK_CLIENT_ID'],
        client_secret: ENV['TINK_CLIENT_SECRET'],
        grant_type: 'authorization_code',
        redirect_uri: ENV['TINK_REDIRECT_URI'],
      })

      if response.status.success?
        @access_token = response.parse['access_token']
        current_user.user_tokens.create(service: 'tink', access_token: @access_token)
        redirect_to root_path, notice: 'Authorization successful'
      else
        render plain: 'Authorization failed'
      end
    end
  end
end
