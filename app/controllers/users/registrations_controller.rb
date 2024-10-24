# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def after_inactive_sign_up_path_for(resource)
      confirmation_instructions_sent_path
    end
  end
end
