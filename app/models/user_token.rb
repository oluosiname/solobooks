# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user

  validates :service, presence: true
  validates :access_token, presence: true

  enum service: { tink: 'tink' }
end
