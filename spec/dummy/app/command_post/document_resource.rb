class DocumentResource < CommandPost::Resource
  field :password_hash, type: :password
  field :cover_image, type: :file
  field :attachments, type: :files
  field :content, type: :rich_text

  searchable :title
  index_fields :id, :title, :published, :created_at
  form_fields :title, :published, :password_hash, :cover_image, :attachments, :content

  menu icon: "document", group: "Content"
end
