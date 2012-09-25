class Presentation < ActiveRecord::Base
  INDEX_FILENAME = "index.html"
  UNPACKED_DIRNAME = "unpacked"

  unloadable

  validates_presence_of :title

  has_friendly_id :title, :use_slug => true
  has_attached_file :contents,
                    :path => ":rails_root/uploaded_presentations/:attachment/:id_partition/:style/:filename"

  has_attached_file :alternative_format

  belongs_to :user
  belongs_to :project
  belongs_to :version

  validates_attachment_presence :contents


  def index_path
    File.join(UNPACKED_DIRNAME, INDEX_FILENAME)
  end

  def path_to(some_asset)
    some_asset.blank? ? index_path : File.join(UNPACKED_DIRNAME, *some_asset)
  end

  def permalink
    friendly_id
  end

  def to_s
    title
  end
end
