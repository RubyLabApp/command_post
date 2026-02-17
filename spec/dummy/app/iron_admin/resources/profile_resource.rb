module IronAdmin
  module Resources
    class ProfileResource < IronAdmin::Resource
      belongs_to :user, display: :name

      field :website, type: :url
      field :avatar_url, type: :url
      field :color_hex, type: :color
      field :hourly_rate, type: :currency, options: { symbol: "$", precision: 2 }

      searchable :bio, :website

      menu icon: "user-circle", group: "Users"
    end
  end
end
