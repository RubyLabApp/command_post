module IronAdmin
  module Resources
    class PostResource < IronAdmin::Resource
      has_and_belongs_to_many :tags

      field :category_tags, type: :tags
      field :body_markdown, type: :markdown

      searchable :title
      menu icon: "document-text", group: "Content"
    end
  end
end
