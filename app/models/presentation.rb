class Presentation < ActiveRecord::Base
  unloadable

  has_friendly_id :title, :use_slug => true
  has_attached_file :contents
  has_attached_file :alternative_format

  validates_attachment_presence :contents
  validates_presence_of :title

  belongs_to :user
  belongs_to :project
  belongs_to :version

  def permalink
    friendly_id
  end

  def to_s
    title
  end
end
