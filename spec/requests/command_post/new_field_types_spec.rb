# frozen_string_literal: true

require "rails_helper"

RSpec.describe "New Field Types", type: :request do
  before do
    CommandPost::ResourceRegistry.register(DocumentResource)
  end

  describe "GET /:resource_name (index)" do
    it "renders documents index successfully" do
      create_list(:document, 3)
      get command_post.resources_path("documents"), as: :html

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /:resource_name/:id (show)" do
    it "renders document show with password field masked" do
      document = create(:document, password_hash: "hashed_secret")
      get command_post.resource_path("documents", document), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("\u2022" * 8)
      expect(response.body).not_to include("hashed_secret")
    end

    it "renders document show with file attachment" do
      document = create(:document)
      document.cover_image.attach(
        io: StringIO.new("image data"),
        filename: "cover.jpg",
        content_type: "image/jpeg"
      )

      get command_post.resource_path("documents", document), as: :html

      expect(response).to have_http_status(:ok)
    end

    it "renders document show with multiple file attachments" do
      document = create(:document)
      document.attachments.attach(
        io: StringIO.new("doc1"),
        filename: "report.pdf",
        content_type: "application/pdf"
      )

      get command_post.resource_path("documents", document), as: :html

      expect(response).to have_http_status(:ok)
    end

    it "renders document show with rich text content" do
      document = create(:document)
      document.update!(content: "Hello <strong>world</strong>")

      get command_post.resource_path("documents", document), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("prose")
    end
  end

  describe "GET /:resource_name/new" do
    it "renders form with password field" do
      get command_post.new_resource_path("documents"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('type="password"')
    end

    it "renders form with file upload field" do
      get command_post.new_resource_path("documents"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('type="file"')
    end

    it "renders form with rich text area" do
      get command_post.new_resource_path("documents"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("trix-editor")
    end

    it "renders form with multipart encoding" do
      get command_post.new_resource_path("documents"), as: :html

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("multipart/form-data")
    end
  end

  describe "POST /:resource_name (create)" do
    it "creates a document with basic fields" do
      expect do
        post command_post.resources_path("documents"),
             params: { record: { title: "Test Document", published: true } },
             as: :html
      end.to change(Document, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end

    it "creates a document with file attachment" do
      file = Rack::Test::UploadedFile.new(
        StringIO.new("file content"),
        "application/pdf",
        true,
        original_filename: "test.pdf"
      )

      post command_post.resources_path("documents"),
           params: { record: { title: "With File", cover_image: file } },
           as: :html

      created_doc = Document.last
      expect(created_doc.cover_image).to be_attached
    end

    it "creates a document with rich text content" do
      post command_post.resources_path("documents"),
           params: { record: { title: "Rich Text Doc", content: "<p>Hello world</p>" } },
           as: :html

      created_doc = Document.last
      expect(created_doc.content.to_plain_text).to include("Hello world")
    end
  end

  describe "PATCH /:resource_name/:id (update)" do
    it "updates a document" do
      existing = create(:document, title: "Old Title")

      patch command_post.resource_path("documents", existing),
            params: { record: { title: "New Title" } },
            as: :html

      expect(existing.reload.title).to eq("New Title")
    end

    it "purges file attachment when checkbox is checked" do
      existing = create(:document)
      existing.cover_image.attach(
        io: StringIO.new("image"),
        filename: "photo.jpg",
        content_type: "image/jpeg"
      )

      expect(existing.cover_image).to be_attached

      patch command_post.resource_path("documents", existing),
            params: { record: { title: existing.title, cover_image_purge: "1" } },
            as: :html

      expect(existing.reload.cover_image).not_to be_attached
    end
  end

  describe "DELETE /:resource_name/:id (destroy)" do
    it "deletes a document" do
      existing = create(:document)

      expect do
        delete command_post.resource_path("documents", existing), as: :html
      end.to change(Document, :count).by(-1)
    end
  end
end
