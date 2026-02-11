class UserResource < CommandPost::Resource
  searchable :name, :email

  filter :role, type: :select

  has_many :licenses
  has_one :profile

  menu priority: 0, icon: "users", group: "Users"
end
