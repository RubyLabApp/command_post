# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Key value field type", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(IronAdmin::Resources::WidgetResource)
  end

  describe "GET /:resource_name/:id (show)" do
    it "renders a definition list with key-value pairs" do
      widget = create(:widget, config_json: '{"host":"localhost","port":"5432"}')
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("host")
      expect(response.body).to include("localhost")
      expect(response.body).to include("port")
      expect(response.body).to include("5432")
    end

    it "handles nil JSON gracefully" do
      widget = create(:widget, config_json: nil)
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
    end

    it "handles invalid JSON gracefully" do
      widget = create(:widget, config_json: "not valid json")
      get iron_admin.resource_path("widgets", widget), as: :html

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name (index)" do
    it "shows compact summary on index" do
      create(:widget, config_json: '{"host":"localhost","port":"5432"}')
      get iron_admin.resources_path("widgets"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("2 keys")
    end
  end

  describe "GET /:resource_name/new" do
    it "renders a textarea for key_value field" do
      get iron_admin.new_resource_path("widgets"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("config_json")
    end
  end

  describe "POST /:resource_name (create)" do
    it "persists JSON key-value data" do
      json = '{"database":"mydb","host":"127.0.0.1"}'
      post iron_admin.resources_path("widgets"),
           params: { record: { name: "KV Widget", config_json: json } },
           as: :html

      expect(Widget.last.config_json).to eq(json)
    end
  end

  describe "PATCH /:resource_name/:id (update)" do
    it "updates JSON key-value data" do
      widget = create(:widget, config_json: '{"old":"data"}')
      new_json = '{"new":"data"}'

      patch iron_admin.resource_path("widgets", widget),
            params: { record: { name: widget.name, config_json: new_json } },
            as: :html

      expect(widget.reload.config_json).to eq(new_json)
    end
  end
end
