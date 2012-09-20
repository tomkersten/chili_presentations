class PresentationsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @presentations = @project.presentations
  end

  def new
    @versions = @project.versions.open
  end

  def upload_complete
    @project.assemblies.create!(assembly_params)
  end

  def show
    if presentation.blank?
      flash[:error] = "The requested presentation does not exist. Please verify the link or send the project owner a message."
      redirect_to(project_presentations_path(@project))
    end
  end

  def destroy
    presentation && presentation.destroy
    flash[:notice] = l(:presentation_deleted_message)
    redirect_to project_presentations_path(@project)
  end

  def edit
    if presentation.blank?
      flash[:error] = "The requested presentation does not exist. Please verify the link or send the project owner a message."
      redirect_to(project_presentations_path(@project))
    else
      @versions = @project.versions.open.push(presentation.version).compact.sort.uniq
    end
  end

  def update
    if presentation.blank?
      flash[:error] = "Hmmm....we couldn't find the presentation you were editing. Someone may have deleted it while you were performing your edits. You may want to send an email to the project owner to find out who has permissions to administer the project presentations."
      redirect_to(project_presentations_path(@project))
    else
      presentation.update_attributes(params[:presentation])
      redirect_to project_presentation_path(@project, presentation)
    end
  end

  def view
    render :text => "Implement me now..."
  end

  private
    def assembly_params
      { :assembly_id => params[:assembly_id],
        :assembly_url => params[:assembly_url],
        :user_id => User.current.id,
        :processed => false
      }
    end

    def presentation
      @presentation ||= @project.presentations.find_by_cached_slug(params[:id])
    end
end
