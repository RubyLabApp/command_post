require "rails_helper"

RSpec.describe "CommandPost::Dashboard", type: :request do
  describe "GET /" do
    context "without dashboard class configured" do
      it "returns success" do
        get command_post.root_path, headers: { "Accept" => "text/html" }

        expect(response).to have_http_status(:ok)
      end

      it "renders dashboard index template" do
        get command_post.root_path, headers: { "Accept" => "text/html" }

        expect(response.body).to be_present
      end
    end

    context "with dashboard class configured" do
      let(:dashboard_class) { Class.new(CommandPost::Dashboard) }

      before do
        CommandPost.dashboard_class = dashboard_class
      end

      it "returns success" do
        get command_post.root_path, headers: { "Accept" => "text/html" }

        expect(response).to have_http_status(:ok)
      end

      it "renders dashboard content" do
        get command_post.root_path, headers: { "Accept" => "text/html" }

        expect(response.body).to be_present
      end
    end
  end
end
