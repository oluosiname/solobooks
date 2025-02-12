# frozen_string_literal: true

module Site
  class LandingPagesController < BaseController
    before_action :redirect_logged_in_user, only: [:show]
    def show
    end
  end
end
