require "rails_helper"

RSpec.describe CommandPost::Configuration do
  subject(:config) { described_class.new }

  describe "defaults" do
    it "sets title to Admin" do
      expect(config.title).to eq("Admin")
    end

    it "sets per_page to 25" do
      expect(config.per_page).to eq(25)
    end

    it "sets default_sort to :created_at" do
      expect(config.default_sort).to eq(:created_at)
    end

    it "sets default_sort_direction to :desc" do
      expect(config.default_sort_direction).to eq(:desc)
    end

    it "sets search_engine to :default" do
      expect(config.search_engine).to eq(:default)
    end

    it "sets logo to nil" do
      expect(config.logo).to be_nil
    end

    it "sets badge_colors to match DEFAULT_BADGE_COLORS" do
      expect(config.badge_colors).to eq(described_class::DEFAULT_BADGE_COLORS)
    end

    it "initializes theme_config as a Theme" do
      expect(config.theme_config).to be_a(CommandPost::Configuration::Theme)
    end

    it "initializes components as a Components" do
      expect(config.components).to be_a(CommandPost::Configuration::Components)
    end

    it "sets authenticate_block to nil" do
      expect(config.authenticate_block).to be_nil
    end

    it "sets current_user_block to nil" do
      expect(config.current_user_block).to be_nil
    end

    it "sets on_action_block to nil" do
      expect(config.on_action_block).to be_nil
    end
  end

  describe "badge_colors" do
    it "is independent from the frozen constant" do
      config.badge_colors[:custom] = "bg-custom-100 text-custom-800"

      expect(config.badge_colors[:custom]).to eq("bg-custom-100 text-custom-800")
      expect(described_class::DEFAULT_BADGE_COLORS).not_to have_key(:custom)
    end

    it "does not share state between instances" do
      config.badge_colors[:new_color] = "test"
      other = described_class.new

      expect(other.badge_colors).not_to have_key(:new_color)
    end
  end

  describe "#authenticate" do
    it "stores the provided block" do
      config.authenticate { |controller| controller.session[:user] }

      expect(config.authenticate_block).to be_a(Proc)
    end

    it "stores a callable block" do
      config.authenticate { |controller| "authenticated" }

      expect(config.authenticate_block.call(nil)).to eq("authenticated")
    end
  end

  describe "#current_user" do
    it "stores the provided block" do
      config.current_user { |controller| controller.current_user }

      expect(config.current_user_block).to be_a(Proc)
    end

    it "stores a callable block" do
      config.current_user { "the_user" }

      expect(config.current_user_block.call).to eq("the_user")
    end
  end

  describe "#on_action" do
    it "stores the provided block" do
      config.on_action { |event| log(event) }

      expect(config.on_action_block).to be_a(Proc)
    end

    it "stores a callable block" do
      config.on_action { |event| event.to_s }

      expect(config.on_action_block.call(:create)).to eq("create")
    end
  end

  describe "#theme" do
    context "with a block" do
      it "yields the theme_config" do
        yielded = nil
        config.theme { |t| yielded = t }

        expect(yielded).to equal(config.theme_config)
      end

      it "returns the theme_config" do
        result = config.theme { |t| t.btn_primary = "custom" }

        expect(result).to equal(config.theme_config)
      end
    end

    context "without a block" do
      it "returns the theme_config" do
        expect(config.theme).to equal(config.theme_config)
      end
    end
  end

  describe "attr_accessors" do
    it "allows setting title" do
      config.title = "Custom Admin"

      expect(config.title).to eq("Custom Admin")
    end

    it "allows setting per_page" do
      config.per_page = 50

      expect(config.per_page).to eq(50)
    end

    it "allows setting default_sort" do
      config.default_sort = :updated_at

      expect(config.default_sort).to eq(:updated_at)
    end

    it "allows setting default_sort_direction" do
      config.default_sort_direction = :asc

      expect(config.default_sort_direction).to eq(:asc)
    end

    it "allows setting search_engine" do
      config.search_engine = :pg_search

      expect(config.search_engine).to eq(:pg_search)
    end

    it "allows setting logo" do
      config.logo = "/images/logo.png"

      expect(config.logo).to eq("/images/logo.png")
    end
  end
end

RSpec.describe CommandPost do
  after { described_class.reset_configuration! }

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(CommandPost::Configuration)
    end

    it "memoizes the configuration" do
      expect(described_class.configuration).to equal(described_class.configuration)
    end
  end

  describe ".configure" do
    it "yields the configuration" do
      described_class.configure do |config|
        config.title = "My Admin"
      end

      expect(described_class.configuration.title).to eq("My Admin")
    end
  end

  describe ".reset_configuration!" do
    it "creates a fresh configuration" do
      old_config = described_class.configuration
      described_class.reset_configuration!

      expect(described_class.configuration).not_to equal(old_config)
    end

    it "resets configuration to defaults" do
      described_class.configure { |c| c.title = "Custom" }
      described_class.reset_configuration!

      expect(described_class.configuration.title).to eq("Admin")
    end

    it "resets dashboard_class to nil" do
      described_class.dashboard_class = "SomeDashboard"
      described_class.reset_configuration!

      expect(described_class.dashboard_class).to be_nil
    end
  end

  describe ".dashboard_class" do
    it "defaults to nil after reset" do
      described_class.reset_configuration!

      expect(described_class.dashboard_class).to be_nil
    end

    it "can be set and read" do
      described_class.dashboard_class = "MyDashboard"

      expect(described_class.dashboard_class).to eq("MyDashboard")
    end
  end
end
