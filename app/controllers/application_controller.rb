# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :authenticate_user!

  layout :layout_by_resource

  class << self
    def default_url_options
      { locale: I18n.locale }
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def layout_by_resource
    if devise_controller? # special definition in devise
      'devise'
    else
      'application'
    end
  end
end
