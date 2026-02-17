module IronAdmin
  module Resources
    class LicenseResource < IronAdmin::Resource
      belongs_to :user, display: :email

      field :license_key, readonly: true
      field :status, type: :badge, colors: { active: :green, expired: :yellow, revoked: :red }

      searchable :license_key

      filter :status, type: :select
      filter :created_at, type: :date_range

      scope :active, -> { where(status: :active) }, default: true
      scope :expired, -> { where(status: :expired) }

      action :revoke, icon: "x-circle", confirm: true do |license|
        license.update!(status: :revoked)
      end

      bulk_action :export do |licenses|
        licenses.pluck(:license_key)
      end

      index_fields :license_key, :status, :expires_at
      form_fields :license_type, :status, :max_devices

      menu priority: 1, icon: "key", group: "Licensing"
    end
  end
end
