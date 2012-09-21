require 'redmine'
require 'chili_presentations'

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :chili_presentations do
  require_dependency 'project'
  Project.send(:include, PresentationProjectPatch) unless Project.included_modules.include? PresentationProjectPatch

  require_dependency 'user'
  User.send(:include, PresentationUserPatch) unless User.included_modules.include? PresentationUserPatch

  require_dependency 'version'
  Version.send(:include, PresentationVersionPatch) unless Version.included_modules.include? PresentationVersionPatch
end


Redmine::Plugin.register 'chili_presentations' do
  name 'Chili Web Presentations plugin'
  author 'Tom Kersten'
  description 'Adds "Presentations" module which allows you to upload a zipped prentation folder including an index.html file and view it in the context of your project-site.'
  version ChiliWebPresentations::VERSION
  url 'https://github.com/tomkersten/chili_presentations'
  author_url 'http://tomkersten.com/'

  project_module :presentations do
    permission :view_presentation_list, {:presentations => [:index]}
    permission :view_specific_presentation, {:presentations => [:show, :view]}
    permission :modify_presentation, {:presentations => [:edit,:update]}, {:require => :member}
    permission :delete_presentation, {:presentations => [:destroy]}, {:require => :member}
    permission :add_presentation, {:presentations => [:new, :create]}, {:require => :member}
  end

  menu :project_menu, :presentations, { :controller => 'videos', :action => 'index' }, :caption => 'Presentations', :param => :project_id
end

#Redmine::WikiFormatting::Macros.register do
#  desc "Provides a link to a video with the title of the video as the link text.\n" +
#       "Usage examples:\n\n" +
#       "  !{{video_link(id)}}\n"
#  macro :video_link do |o, args|
#    video_id = args[0]
#    video = Video.find(video_id)
#    VideosHelper.link_to_video(video)
#  end
#end

#Redmine::WikiFormatting::Macros.register do
#  desc "Creates a horizontal list of videos associated with the specified verison.\n" +
#       "Usage examples:\n\n" +
#       "  !{{version_video_thumbnails(version_id)}}\n"
#  macro :version_video_thumbnails do |o, args|
#    version_id = args[0]
#    version = Version.find_by_name(version_id) || Version.find_by_id(version_id)
#    if version.blank?
#      "'#{version_id}' version not found"
#    else
#      "#{VideosHelper.video_thumbnail_list(version.videos)}"
#    end
#  end
#end
