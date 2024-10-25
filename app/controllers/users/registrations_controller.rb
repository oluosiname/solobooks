# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def new
      Rails.logger.info "Postmark API Token: #{ENV["POSTMARK_API_TOKEN"]}"
      build_resource
      yield resource if block_given?
      respond_with resource
    end

    def after_inactive_sign_up_path_for(resource)
      confirmation_instructions_sent_path
    end
  end
end
