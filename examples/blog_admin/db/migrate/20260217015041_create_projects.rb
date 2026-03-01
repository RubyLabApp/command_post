class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :status                # :radio — active/paused/archived
      t.string :permissions            # :boolean_group — CSV of read/write/deploy/admin
      t.string :cover_image_url        # :external_image
      t.integer :progress              # :progress_bar — 0-100
      t.text :config                   # :key_value — JSON
      t.text :deploy_script            # :code — deployment script
      t.string :api_key                # :hidden
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
