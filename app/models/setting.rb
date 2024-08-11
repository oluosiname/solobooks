# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :profile
  has_one :user, through: :profile
  belongs_to :currency

  LANGUAGES = {
    'English' => 'en',
    'Deutsch' => 'de',
  }
end
