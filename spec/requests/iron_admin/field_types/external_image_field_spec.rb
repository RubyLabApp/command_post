# frozen_string_literal: true

require "rails_helper"

RSpec.describe "External image field type", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::WidgetResource)
  end

  describe "GET /:resource_name/:id (show)" do
    it "renders an img tag with the URL" do
      widget = create(:widget, image_url: "https://example.com/photo.jpg")
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("https://example.com/photo.jpg")
      expect(response.body).to include("<img")
    end

    it "does not render javascript: URLs" do
      widget = create(:widget, image_url: "javascript:alert(1)")
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("javascript:")
    end

    it "handles nil URL gracefully" do
      widget = create(:widget, image_url: nil)
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/new" do
    it "renders URL text input for external image" do
      get iron_admin.new_resource_path("widgets"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("image_url")
    end
  end

  describe "POST /:resource_name (create)" do
    it "persists the image URL" do
      post iron_admin.resources_path("widgets"),
           params: { record: { name: "Image Widget", image_url: "https://example.com/new.jpg" } },
           as: :html

      expect(Widget.last.image_url).to eq("https://example.com/new.jpg")
    end
  end

  describe "PATCH /:resource_name/:id (update)" do
    it "updates the image URL" do
      widget = create(:widget, image_url: "https://example.com/old.jpg")

      patch iron_admin.resource_path("widgets", widget),
            params: { record: { name: widget.name, image_url: "https://example.com/updated.jpg" } },
            as: :html

      expect(widget.reload.image_url).to eq("https://example.com/updated.jpg")
    end
  end
end
