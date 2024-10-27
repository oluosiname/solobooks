# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user

  encrypts :access_token
  encrypts :refresh_token

  enum service: {
    tink: 'tink',
  }
end
