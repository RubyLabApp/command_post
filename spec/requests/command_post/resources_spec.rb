require "rails_helper"
require_relative "../../support/test_resources"

RSpec.describe "CommandPost::Resources", type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
  end

  describe "GET /:resource_name" do
    it "returns success" do
      create_list(:user, 3)
      get command_post.resources_path("users"), headers: { "Accept" => "text/html" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/:id" do
    it "shows a record" do
      user = create(:user)
      get command_post.resource_path("users", user), as: :html
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/new" do
    it "shows new form" do
      get command_post.new_resource_path("users"), as: :html
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/:id/edit" do
    it "shows edit form" do
      user = create(:user)
      get command_post.edit_resource_path("users", user), as: :html
      expect(response).to have_http_status(:ok)
    end
  end
end
