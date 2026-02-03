class UserResource < CommandPost::Resource
  searchable :name, :email

  filter :role, type: :select

  has_many :licenses

  menu priority: 0, icon: "users", group: "Users"
end
