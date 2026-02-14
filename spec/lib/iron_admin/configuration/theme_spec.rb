require "rails_helper"

RSpec.describe IronAdmin::Configuration::Theme do
  subject(:theme) { described_class.new }

  describe "button defaults" do
    it "sets btn_primary" do
      expect(theme.btn_primary).to include("bg-indigo-600")
    end

    it "sets btn_secondary" do
      expect(theme.btn_secondary).to include("bg-white")
    end

    it "sets btn_danger" do
      expect(theme.btn_danger).to include("bg-red-600")
    end

    it "sets btn_ghost" do
      expect(theme.btn_ghost).to include("bg-gray-100")
    end
  end

  describe "link defaults" do
    it "sets link" do
      expect(theme.link).to include("text-indigo-600")
    end

    it "sets link_muted" do
      expect(theme.link_muted).to include("text-gray-500")
    end
  end

  describe "input defaults" do
    it "sets focus_ring" do
      expect(theme.focus_ring).to include("focus:ring")
    end

    it "sets input_border" do
      expect(theme.input_border).to include("border-gray-300")
    end

    it "sets input_focus" do
      expect(theme.input_focus).to include("focus:border-indigo-500")
    end

    it "sets checkbox_checked" do
      expect(theme.checkbox_checked).to include("checked:bg-indigo-600")
    end
  end

  describe "scope defaults" do
    it "sets scope_active" do
      expect(theme.scope_active).to include("border-indigo-600")
    end

    it "sets scope_inactive" do
      expect(theme.scope_inactive).to include("border-transparent")
    end
  end

  describe "sidebar defaults" do
    it "sets sidebar_bg" do
      expect(theme.sidebar_bg).to eq("bg-gray-900")
    end

    it "sets sidebar_title" do
      expect(theme.sidebar_title).to eq("text-white")
    end

    it "sets sidebar_link" do
      expect(theme.sidebar_link).to eq("text-gray-300")
    end

    it "sets sidebar_link_hover" do
      expect(theme.sidebar_link_hover).to include("hover:bg-gray-800")
    end

    it "sets sidebar_group_label" do
      expect(theme.sidebar_group_label).to eq("text-gray-400")
    end
  end

  describe "navbar defaults" do
    it "sets navbar_bg" do
      expect(theme.navbar_bg).to eq("bg-white")
    end

    it "sets navbar_border" do
      expect(theme.navbar_border).to eq("border-gray-200")
    end

    it "sets navbar_search_bg" do
      expect(theme.navbar_search_bg).to eq("bg-gray-50")
    end

    it "sets navbar_search_focus_bg" do
      expect(theme.navbar_search_focus_bg).to include("focus:bg-white")
    end
  end

  describe "table defaults" do
    it "sets table_header_bg" do
      expect(theme.table_header_bg).to eq("bg-gray-50")
    end

    it "sets table_row_hover" do
      expect(theme.table_row_hover).to include("hover:bg-gray-50")
    end

    it "sets table_border" do
      expect(theme.table_border).to eq("divide-gray-200")
    end
  end

  describe "card defaults" do
    it "sets card_bg" do
      expect(theme.card_bg).to eq("bg-white")
    end

    it "sets card_border" do
      expect(theme.card_border).to eq("border-gray-200")
    end

    it "sets card_shadow" do
      expect(theme.card_shadow).to eq("shadow")
    end
  end

  describe "typography defaults" do
    it "sets font_family to empty string" do
      expect(theme.font_family).to eq("")
    end

    it "sets heading_weight" do
      expect(theme.heading_weight).to eq("font-bold")
    end

    it "sets body_text" do
      expect(theme.body_text).to eq("text-gray-900")
    end

    it "sets muted_text" do
      expect(theme.muted_text).to eq("text-gray-500")
    end

    it "sets label_text" do
      expect(theme.label_text).to eq("text-gray-700")
    end
  end

  describe "layout defaults" do
    it "sets border_radius" do
      expect(theme.border_radius).to eq("rounded-lg")
    end

    it "sets main_bg" do
      expect(theme.main_bg).to eq("bg-gray-50")
    end

    it "sets badge_count" do
      expect(theme.badge_count).to include("bg-indigo-600")
    end
  end

  describe "chart defaults" do
    it "sets chart_colors as array of CSS color values" do
      expect(theme.chart_colors).to be_an(Array)
      expect(theme.chart_colors.length).to eq(6)
      expect(theme.chart_colors.first).to include("rgba")
    end

    it "sets chart_border_color" do
      expect(theme.chart_border_color).to eq("rgb(99, 102, 241)")
    end
  end

  describe "customization" do
    it "allows setting btn_primary" do
      theme.btn_primary = "custom-class"

      expect(theme.btn_primary).to eq("custom-class")
    end

    it "allows setting sidebar_bg" do
      theme.sidebar_bg = "bg-blue-900"

      expect(theme.sidebar_bg).to eq("bg-blue-900")
    end

    it "allows setting border_radius" do
      theme.border_radius = "rounded-xl"

      expect(theme.border_radius).to eq("rounded-xl")
    end
  end

  describe "nested style groups" do
    described_class::STYLE_GROUPS.each do |group|
      it "exposes #{group} as a Styles object" do
        expect(theme.public_send(group)).to be_a(IronAdmin::Configuration::Theme::Styles)
      end
    end

    it "provides button.base for base button classes" do
      expect(theme.button.base).to include("inline-flex")
    end

    it "provides button.variants as a hash of variant classes" do
      expect(theme.button.variants).to be_a(Hash)
      expect(theme.button.variants[:primary]).to include("bg-indigo-600")
    end

    it "provides button.sizes as a hash of size classes" do
      expect(theme.button.sizes).to be_a(Hash)
      expect(theme.button.sizes[:md]).to include("py-2")
    end

    it "provides badge.colors as a hash of color classes" do
      expect(theme.badge.colors).to be_a(Hash)
      expect(theme.badge.colors[:green]).to include("bg-green-100")
    end

    it "provides form.input_base for base input classes" do
      expect(theme.form.input_base).to include("block w-full")
    end

    it "provides table.header_bg for table header" do
      expect(theme.table.header_bg).to eq("bg-gray-50")
    end

    it "provides sidebar.bg for sidebar background" do
      expect(theme.sidebar.bg).to eq("bg-gray-900")
    end

    it "provides layout.shell for shell classes" do
      expect(theme.layout.shell).to include("flex")
    end

    it "provides alert.variants as nested hashes" do
      expect(theme.alert.variants).to be_a(Hash)
      expect(theme.alert.variants[:success][:bg]).to eq("bg-green-50")
    end
  end

  describe "flat and nested aliases share state" do
    it "reflects flat writes in nested reads" do
      theme.btn_primary = "custom-primary"

      expect(theme.button.variants[:primary]).to eq("custom-primary")
    end

    it "reflects nested writes in flat reads" do
      theme.button.variants[:primary] = "nested-primary"

      expect(theme.btn_primary).to eq("nested-primary")
    end

    it "reflects flat sidebar_bg writes in nested sidebar.bg reads" do
      theme.sidebar_bg = "bg-custom"

      expect(theme.sidebar.bg).to eq("bg-custom")
    end

    it "reflects nested sidebar.bg writes in flat sidebar_bg reads" do
      theme.sidebar.bg = "bg-nested"

      expect(theme.sidebar_bg).to eq("bg-nested")
    end
  end

  describe "#apply_preset" do
    it "resets all style groups to preset defaults" do
      theme.btn_primary = "custom-classes"
      theme.sidebar_bg = "bg-custom"
      theme.apply_preset(IronAdmin::Themes::Tailwind)

      expect(theme.btn_primary).to include("bg-indigo-600")
      expect(theme.sidebar_bg).to eq("bg-gray-900")
    end

    context "with a custom preset" do
      let(:custom_preset) do
        Module.new do
          def self.defaults
            IronAdmin::Themes::Tailwind.defaults.merge(
              sidebar: { bg: "bg-blue-900", title: "text-white",
                         link: "text-blue-200", link_hover: "hover:bg-blue-800",
                         group_label: "text-blue-400", nav: "w-64",
                         link_base: "flex", group_label_base: "px-3",
                         logo_height: "h-8", section_padding: "p-6",
                         nav_padding: "px-3", }
            )
          end
        end
      end

      it "applies custom preset values" do
        theme.apply_preset(custom_preset)

        expect(theme.sidebar_bg).to eq("bg-blue-900")
      end

      it "preserves non-overridden group defaults" do
        theme.apply_preset(custom_preset)

        expect(theme.btn_primary).to include("bg-indigo-600")
      end
    end
  end
end
