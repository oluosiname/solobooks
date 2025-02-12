require 'rails_helper'

RSpec.describe "Site::LandingPages", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/site/landing_pages/show"
      expect(response).to have_http_status(:success)
    end
  end

end
