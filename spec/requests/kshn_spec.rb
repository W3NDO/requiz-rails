require 'rails_helper'

RSpec.describe "Kshns", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/kshn/index"
      expect(response).to have_http_status(:success)
    end
  end

end
