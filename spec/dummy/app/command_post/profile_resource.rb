class ProfileResource < CommandPost::Resource
  belongs_to :user, display: :name

  searchable :bio, :website

  menu icon: "user-circle", group: "Users"
end
