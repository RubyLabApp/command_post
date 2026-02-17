require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe "IronAdmin::Search", type: :request do
  before do
    IronAdmin.reset_configuration!
    IronAdmin::ResourceRegistry.reset!
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
  end

  describe "GET /search" do
    it "returns matching results" do
      create(:user, name: "John Doe", email: "john@example.com")
      create(:user, name: "Jane Smith", email: "jane@example.com")

      get iron_admin.search_path(q: "John")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("John Doe")
      expect(response.body).not_to include("Jane Smith")
    end

    it "returns empty when no query" do
      get iron_admin.search_path
      expect(response).to have_http_status(:ok)
    end
  end
end
