class TagResource < CommandPost::Resource
  searchable :name

  menu icon: "tag", group: "Content"
end
