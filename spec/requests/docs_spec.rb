require 'rails_helper'

RSpec.describe "Docs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/docs/index"
      expect(response).to have_http_status(:success)
    end
  end

end
