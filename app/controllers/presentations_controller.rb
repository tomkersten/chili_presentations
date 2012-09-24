class PresentationsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @presentations = @project.presentations
  end

  def new
    @versions = @project.versions.open
  end

  def create
    @presentation = @project.presentations.new(presentation_params)

    if @presentation.save
      # TODO: unzip to a folder
      # TODO: rename index.html -> index.erb
      redirect_to project_presentations_path(@project)
    else
      render :action => :new
    end
  end

  # TODO: Set up something on nginx for x-file stuff...pass auth to app, but
  #       serve static files w/ nginx.
  # TODO: Handle CSS, JS, and other static asset requests
  def show
    if presentation.blank?
      flash[:error] = "The requested presentation does not exist. Please verify the link or send the project owner a message."
      redirect_to(project_presentations_path(@project))
    end

    render :file => presentation.path_to(params[:static_asset_path]), :layout => false
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
    else
      presentation.title = presentation_params[:title]
      presentation.description = presentation_params[:description]
      presentation.save!
    end

    redirect_to project_presentations_path(@project)
  end

  private
    def presentation_params
      params[:presentation].merge({:user_id => User.current.id})
    end

    def presentation
      @presentation ||= @project.presentations.find_by_cached_slug(params[:id])
    end
end
