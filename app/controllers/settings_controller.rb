# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    @payment_detail = current_user.payment_detail || current_user.build_payment_detail
  end
end
