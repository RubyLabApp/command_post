# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Hidden field type", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::WidgetResource)
  end

  describe "GET /:resource_name/:id (show)" do
    it "does not display the hidden field value" do
      widget = create(:widget, secret_token: "supersecret")
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("supersecret")
    end
  end

  describe "GET /:resource_name/new" do
    it "renders hidden input for hidden field" do
      get iron_admin.new_resource_path("widgets"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('type="hidden"')
      expect(response.body).to include("secret_token")
    end
  end

  describe "GET /:resource_name/:id/edit" do
    it "renders hidden input with existing value" do
      widget = create(:widget, secret_token: "existing_token")
      get iron_admin.edit_resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('type="hidden"')
      expect(response.body).to include("existing_token")
    end
  end

  describe "POST /:resource_name (create)" do
    it "persists the hidden field value" do
      post iron_admin.resources_path("widgets"),
           params: { record: { name: "Test Widget", secret_token: "new_secret" } },
           as: :html

      expect(Widget.last.secret_token).to eq("new_secret")
    end
  end

  describe "PATCH /:resource_name/:id (update)" do
    it "updates the hidden field value" do
      widget = create(:widget, secret_token: "old_secret")

      patch iron_admin.resource_path("widgets", widget),
            params: { record: { name: widget.name, secret_token: "updated_secret" } },
            as: :html

      expect(widget.reload.secret_token).to eq("updated_secret")
    end
  end
end
