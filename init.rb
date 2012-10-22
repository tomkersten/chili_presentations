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
  name 'Chili Presentations plugin'
  author 'Tom Kersten'
  description 'Adds "Presentations" module which allows you to upload a zipped prentation folder including an index.html file and view it in the context of your project-site.'
  version ChiliPresentations::VERSION
  url 'https://github.com/tomkersten/chili_presentations'
  author_url 'http://tomkersten.com/'

  project_module :presentations do
    permission :view_presentation_list, {:presentations => [:index]}
    permission :view_specific_presentation, {:presentations => [:show]}
    permission :download_presentation, {:presentations => [:download, :instructions]}, {:require => :member}
    permission :modify_presentation, {:presentations => [:edit,:update]}, {:require => :member}
    permission :delete_presentation, {:presentations => [:destroy]}, {:require => :member}
    permission :add_presentation, {:presentations => [:new, :create]}, {:require => :member}
  end

  menu :project_menu, :presentations, { :controller => 'presentations', :action => 'index' }, :caption => 'Presentations', :param => :project_id

  ActiveRecord::Base.observers << :presentation_observer
end

Redmine::WikiFormatting::Macros.register do
  desc "Provides a link to a Presentation with the title of the Presentation as the link text.\n" +
       "Usage examples:\n\n" +
       "  !{{presentation_link(id)}}\n"
  macro :presentation_link do |o, args|
    presentation_id = args[0]
    presentation = Presentation.find(presentation_id)
    PresentationsHelper.link_to_presentation(presentation)
  end
end
