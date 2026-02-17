module IronAdmin
  module Resources
    class TagResource < IronAdmin::Resource
      searchable :name

      menu icon: "tag", group: "Content"
    end
  end
end
