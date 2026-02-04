require "rails_helper"

RSpec.describe "CommandPost Soft Delete Integration", type: :request do
  # Create a temporary table with deleted_at column for testing
  before(:all) do
    ActiveRecord::Base.connection.create_table :posts, force: true do |t|
      t.string :title
      t.text :body
      t.datetime :deleted_at
      t.timestamps
    end

    # Define the Post model dynamically
    Object.const_set(:Post, Class.new(ApplicationRecord) do
      # Simulate paranoia/discard default scope
      default_scope { where(deleted_at: nil) }
    end)
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table :posts, if_exists: true
    Object.send(:remove_const, :Post) if defined?(Post)
  end

  # Create PostResource for testing
  let(:post_resource) do
    Class.new(CommandPost::Resource) do
      self.model_class_override = Post

      def self.name
        "PostResource"
      end

      def self.resource_name
        "posts"
      end
    end
  end

  before do
    CommandPost.reset_configuration!
    CommandPost::ResourceRegistry.reset!
    CommandPost::ResourceRegistry.register(post_resource)
  end

  describe "GET /:resource_name with soft delete scopes" do
    let!(:active_post) { Post.create!(title: "Active Post", body: "Content") }
    let!(:deleted_post) { Post.unscoped.create!(title: "Deleted Post", body: "Content", deleted_at: Time.current) }

    it "shows only non-deleted records by default" do
      get command_post.resources_path("posts"), as: :html
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Active Post")
      expect(response.body).not_to include("Deleted Post")
    end

    it "shows all records with with_deleted scope" do
      get command_post.resources_path("posts"), params: { scope: "with_deleted" }, as: :html
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Active Post")
      expect(response.body).to include("Deleted Post")
    end

    it "shows only deleted records with only_deleted scope" do
      get command_post.resources_path("posts"), params: { scope: "only_deleted" }, as: :html
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("Active Post")
      expect(response.body).to include("Deleted Post")
    end
  end

  describe "POST /:resource_name/:id/actions/restore" do
    let!(:deleted_post) { Post.unscoped.create!(title: "Deleted Post", body: "Content", deleted_at: Time.current) }

    it "restores a soft deleted record" do
      expect(deleted_post.deleted_at).to be_present

      # The restore action needs to find the record with unscoped query
      # Since the controller uses model.find, we need to use unscoped
      post command_post.resource_action_path("posts", deleted_post.id, "restore"), as: :html

      expect(deleted_post.reload.deleted_at).to be_nil
    end

    it "redirects to the show page after restore" do
      post command_post.resource_action_path("posts", deleted_post.id, "restore"), as: :html
      expect(response).to redirect_to(command_post.resource_path("posts", deleted_post))
    end
  end
end
