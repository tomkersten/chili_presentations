class Presentation < ActiveRecord::Base
  INDEX_FILENAME = "index.html.erb"
  UNPACKED_DIRNAME = "unpacked"

  unloadable

  validates_presence_of :title

  has_friendly_id :title, :use_slug => true
  has_attached_file :contents
  has_attached_file :alternative_format

  belongs_to :user
  belongs_to :project
  belongs_to :version

  validates_attachment_presence :contents


  def index_path
    File.join(unpacked_base, INDEX_FILENAME)
  end

  def path_to(some_asset)
    some_asset.blank? ? index_path : File.join(unpacked_base, *some_asset)
  end

  def permalink
    friendly_id
  end

  def to_s
    title
  end

  def unpacked_base
    File.join(File.dirname(contents.path), UNPACKED_DIRNAME)
  end
  private :unpacked_base
end
