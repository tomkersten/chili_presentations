class Presentation < ActiveRecord::Base
  unloadable

  has_friendly_id :title, :use_slug => true

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
