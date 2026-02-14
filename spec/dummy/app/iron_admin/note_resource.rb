class NoteResource < IronAdmin::Resource
  belongs_to :notable, polymorphic: true, types: [User, License]

  index_fields :id, :title, :notable, :created_at
  form_fields :title, :body, :notable
end
