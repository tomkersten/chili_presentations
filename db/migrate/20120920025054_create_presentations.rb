class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :unzipped_location, :string
      t.integer :project_id, :user_id, :version_id
      t.string :cached_slug
      t.has_attached_file :contents
      t.has_attached_file :alternative_format
      t.timestamps
    end

    add_index  :presentations, :cached_slug, :unique => true
  end

  def self.down
    remove_index :presentations, :column => :cached_slug

    drop_table :presentations
  end
end
