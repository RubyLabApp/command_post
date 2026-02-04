require "rails_helper"

RSpec.describe CommandPost::ApplicationController, type: :request do
  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(UserResource)
  end

  describe "authentication" do
    context "when authenticate block is configured" do
      it "executes the authenticate block" do
        executed = false
        CommandPost.configure do |config|
          config.authenticate { |_controller| executed = true }
        end

        get command_post.resources_path("users"), as: :html
        expect(executed).to be true
      end

      it "can redirect from authenticate block" do
        CommandPost.configure do |config|
          config.authenticate { |controller| controller.redirect_to "/login" }
        end

        get command_post.resources_path("users"), as: :html
        expect(response).to redirect_to("/login")
      end
    end

    context "when authenticate block is not configured" do
      it "allows access" do
        get command_post.resources_path("users"), as: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "current_user helper" do
    context "when current_user block is configured" do
      let(:user) { create(:user, name: "Admin") }

      it "executes the current_user block" do
        CommandPost.configure do |config|
          config.current_user { |_controller| user }
        end

        get command_post.resources_path("users"), as: :html
        expect(response).to have_http_status(:ok)
      end

      it "provides current user to views" do
        CommandPost.configure do |config|
          config.current_user { |_controller| user }
        end

        get command_post.root_path, as: :html
        expect(response).to have_http_status(:ok)
      end
    end

    context "when current_user block is not configured" do
      it "returns nil for current_user" do
        get command_post.resources_path("users"), as: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
