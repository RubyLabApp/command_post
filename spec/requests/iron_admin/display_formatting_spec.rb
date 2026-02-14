# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Display Formatting", type: :request do
  before do
    IronAdmin::ResourceRegistry.register(ProfileResource)
  end

  describe "URL field type" do
    describe "GET /:resource_name/:id (show)" do
      it "renders URL as clickable link" do
        profile = create(:profile, website: "https://example.com")
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('href="https://example.com"')
        expect(response.body).to include('target="_blank"')
        expect(response.body).to include("noopener noreferrer")
      end

      it "handles blank URL gracefully" do
        profile = create(:profile, website: "")
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
      end

      it "handles nil URL gracefully" do
        profile = create(:profile, website: nil)
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /:resource_name/new" do
      it "renders form with URL input" do
        get iron_admin.new_resource_path("profiles"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('type="url"')
        expect(response.body).to include("https://")
      end
    end

    describe "POST /:resource_name (create)" do
      it "creates record with URL field" do
        user = create(:user)
        post iron_admin.resources_path("profiles"),
             params: { record: { user_id: user.id, website: "https://newsite.com" } },
             as: :html

        expect(Profile.last.website).to eq("https://newsite.com")
      end
    end
  end

  describe "email field type" do
    describe "GET /:resource_name/:id (show)" do
      it "renders email as mailto link" do
        user = create(:user, email: "test@example.com")
        get iron_admin.resource_path("users", user), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('href="mailto:test@example.com"')
      end

      it "handles blank email gracefully" do
        user = create(:user)
        allow_any_instance_of(User).to receive(:email).and_return("") # rubocop:disable RSpec/AnyInstance
        get iron_admin.resource_path("users", user), as: :html

        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /:resource_name/new" do
      it "renders form with email input" do
        get iron_admin.new_resource_path("users"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('type="email"')
        expect(response.body).to include("user@example.com")
      end
    end
  end

  describe "color field type" do
    describe "GET /:resource_name/:id (show)" do
      it "renders color swatch with hex code" do
        profile = create(:profile, color_hex: "#3b82f6")
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("#3b82f6")
        expect(response.body).to include("background-color:")
      end

      it "handles blank color gracefully" do
        profile = create(:profile, color_hex: "")
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
      end

      it "handles nil color gracefully" do
        profile = create(:profile, color_hex: nil)
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /:resource_name/new" do
      it "renders form with color picker" do
        get iron_admin.new_resource_path("profiles"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('type="color"')
      end
    end

    describe "POST /:resource_name (create)" do
      it "creates record with color field" do
        user = create(:user)
        post iron_admin.resources_path("profiles"),
             params: { record: { user_id: user.id, color_hex: "#ff5733" } },
             as: :html

        expect(Profile.last.color_hex).to eq("#ff5733")
      end
    end
  end

  describe "currency field type" do
    describe "GET /:resource_name/:id (show)" do
      it "renders currency with symbol and formatting" do
        profile = create(:profile, hourly_rate: 1234.56)
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("$")
        expect(response.body).to include("1,234.56")
        expect(response.body).to include("tabular-nums")
      end

      it "handles nil value gracefully" do
        profile = create(:profile, hourly_rate: nil)
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
      end

      it "handles zero value" do
        profile = create(:profile, hourly_rate: 0)
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("$0.00")
      end
    end

    describe "GET /:resource_name/new" do
      it "renders form with currency input" do
        get iron_admin.new_resource_path("profiles"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('step="0.01"')
        expect(response.body).to include("$")
      end
    end

    describe "POST /:resource_name (create)" do
      it "creates record with currency field" do
        user = create(:user)
        post iron_admin.resources_path("profiles"),
             params: { record: { user_id: user.id, hourly_rate: "99.99" } },
             as: :html

        expect(Profile.last.hourly_rate).to eq(99.99)
      end
    end
  end

  describe "boolean smart rendering" do
    describe "GET /:resource_name/:id (show)" do
      it "renders true as green checkmark icon" do
        user = create(:user, active: true)
        get iron_admin.resource_path("users", user), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("text-green-500")
      end

      it "renders false as red X icon" do
        user = create(:user, active: false)
        get iron_admin.resource_path("users", user), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("text-red-400")
      end
    end

    describe "GET /:resource_name (index)" do
      it "renders boolean icons on index page" do
        create(:user, active: true)
        create(:user, active: false)
        get iron_admin.resources_path("users"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("text-green-500")
        expect(response.body).to include("text-red-400")
      end
    end
  end

  describe "date/datetime formatting" do
    describe "GET /:resource_name/:id (show)" do
      it "formats datetime in human-readable format" do
        user = create(:user)
        get iron_admin.resource_path("users", user), as: :html

        expect(response).to have_http_status(:ok)
        # created_at should be formatted like "Feb 10, 2026 at 3:45 PM"
        expect(response.body).to match(/\w{3} \d{1,2}, \d{4} at/)
      end
    end

    describe "GET /:resource_name (index)" do
      it "formats datetime on index page" do
        create(:user)
        get iron_admin.resources_path("users"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/\w{3} \d{1,2}, \d{4} at/)
      end
    end
  end

  describe "text truncation on index" do
    describe "GET /:resource_name (index)" do
      it "truncates long text on index page" do
        long_bio = "A" * 100
        user = create(:user)
        create(:profile, user: user, bio: long_bio)
        get iron_admin.resources_path("profiles"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("...")
        expect(response.body).to include("title=")
      end

      it "does not truncate short text" do
        user = create(:user)
        create(:profile, user: user, bio: "Short bio")
        get iron_admin.resources_path("profiles"), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Short bio")
      end
    end

    describe "GET /:resource_name/:id (show)" do
      it "shows full text on show page" do
        long_bio = "A" * 100
        user = create(:user)
        profile = create(:profile, user: user, bio: long_bio)
        get iron_admin.resource_path("profiles", profile), as: :html

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(long_bio)
      end
    end
  end
end
