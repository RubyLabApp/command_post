require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe "CommandPost::Exports", type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
  end

  describe "GET /:resource_name/export.csv" do
    it "returns CSV" do
      create(:user, name: "John", email: "john@test.com")

      get command_post.export_path("users", format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include("john@test.com")
    end
  end

  describe "GET /:resource_name/export.json" do
    it "returns JSON" do
      create(:user, name: "John", email: "john@test.com")

      get command_post.export_path("users", format: :json)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
    end
  end
end
