class Presentation < ActiveRecord::Base
  UPLOAD_BASE_DIR = File.join(Rails.root, "uploaded_presentations")
  INDEX_FILENAME = "index.html"
  UNPACKED_DIRNAME = "unpacked"

  unloadable

  validates_presence_of :title

  has_friendly_id :title, :use_slug => true
  has_attached_file :contents,
                    :path => "#{UPLOAD_BASE_DIR}/:attachment/:id_partition/:style/:filename"

  has_attached_file :alternative_format

  belongs_to :user
  belongs_to :project
  belongs_to :version

  validates_attachment_presence :contents


  def index_path
    File.join(path_without_upload_base_dir, UNPACKED_DIRNAME, INDEX_FILENAME)
  end

  def x_accel_redirect_path_to(some_asset)
    some_asset.blank? ? index_path : File.join(path_without_upload_base_dir, UNPACKED_DIRNAME, *some_asset)
  end

  def permalink
    friendly_id
  end

  def to_s
    title
  end

  def path_without_upload_base_dir
    File.dirname(contents.path.sub(/#{UPLOAD_BASE_DIR}/, ''))
  end
  private :path_without_upload_base_dir
end
