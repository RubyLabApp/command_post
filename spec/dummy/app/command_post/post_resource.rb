class PostResource < CommandPost::Resource
  searchable :title
  menu icon: "document-text", group: "Content"
end
