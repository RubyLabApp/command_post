require "rails_helper"

RSpec.describe IronAdmin::ApplicationController, type: :request do
  before do
    IronAdmin.reset_configuration!
    IronAdmin::ResourceRegistry.reset!
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::UserResource)
  end

  describe "authentication" do
    context "when authenticate block is configured" do
      it "executes the authenticate block" do
        executed = false
        IronAdmin.configure do |config|
          config.authenticate { |_controller| executed = true }
        end

        get iron_admin.resources_path("users"), as: :html
        expect(executed).to be true
      end

      it "can redirect from authenticate block" do
        IronAdmin.configure do |config|
          config.authenticate { |controller| controller.redirect_to "/login" }
        end

        get iron_admin.resources_path("users"), as: :html
        expect(response).to redirect_to("/login")
      end
    end

    context "when authenticate block is not configured" do
      it "allows access" do
        get iron_admin.resources_path("users"), as: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "current_user helper" do
    context "when current_user block is configured" do
      it "executes the current_user block" do
        test_user = create(:user, name: "Admin")
        IronAdmin.configure do |config|
          config.current_user { |_controller| test_user }
        end

        get iron_admin.resources_path("users"), as: :html
        expect(response).to have_http_status(:ok)
      end

      it "provides current user to views" do
        test_user = create(:user, name: "Admin")
        IronAdmin.configure do |config|
          config.current_user { |_controller| test_user }
        end

        get iron_admin.root_path, as: :html
        expect(response).to have_http_status(:ok)
      end
    end

    context "when current_user block is not configured" do
      it "returns nil for current_user" do
        get iron_admin.resources_path("users"), as: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
