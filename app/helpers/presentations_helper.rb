module PresentationsHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  extend self

  def gravatar_enabled?
    Setting['gravatar_enabled'] == '1'
  end

  def link_to_presentation_macro_markup(presentation)
    "{{presentation_link(#{presentation.permalink})}}"
  end

  def link_to_presentation(presentation)
    return "[Presentation not provided]" unless presentation.instance_of?(Presentation)
    "<a href='#{prjct_presentation_path(presentation.project, presentation)}' class='presentation-link'>#{presentation.title}</a>"
  end

  private
    def prjct_presentation_path(project, presentation)
      "/projects/#{project.to_param}/presentations/#{presentation.to_param}"
    end

    def usr_path(user)
      "/users/#{user.to_param}"
    end
end
