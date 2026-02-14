class TagResource < IronAdmin::Resource
  searchable :name

  menu icon: "tag", group: "Content"
end
