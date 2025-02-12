# frozen_string_literal: true

module Site
  class BaseController < ApplicationController
    before_action :set_locale
    before_action :authenticate_user!

    skip_before_action :authenticate_user!

    layout :layout_by_resource

    class << self
      def default_url_options
        { locale: I18n.locale }
      end
    end

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def layout_by_resource
      'site'
    end

    def redirect_logged_in_user
      if user_signed_in?
        redirect_to root_url(subdomain: 'app', locale: I18n.locale)
      end
    end
  end
end
