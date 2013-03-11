class PresentationsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  def index
    @presentations = @project.presentations
  end

  def instructions
  end

  def new
    @versions = @project.versions.open
  end

  def create
    @presentation = @project.presentations.new(presentation_params)

    if @presentation.save
      redirect_to project_presentations_path(@project)
    else
      render :action => :new
    end
  end

  # Defers serving files to nginx via the X-Accel-Redirect header
  def show
    if presentation.blank?
      flash[:error] = "The requested presentation does not exist. Please verify the link or send the project owner a message."
      redirect_to(project_presentations_path(@project))
    end

    head :x_accel_redirect => presentation.x_accel_redirect_path_to(params[:static_asset_path]), :content_type => requested_content_type
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

  def download
    send_file presentation.contents.path,
              :filename => presentation.contents_file_name,
              :type => presentation.contents.content_type,
              :streaming => true
  end

  private
    def presentation_params
      params[:presentation].merge({:user_id => User.current.id})
    end

    def presentation
      @presentation ||= @project.presentations.find_by_cached_slug(params[:id])
    end

    def requested_content_type
      case presentation.x_accel_redirect_path_to(params[:static_asset_path])
      when /\.css$/ then "text/css"
      when /\.js$/ then "text/javascript"
      when /\.png$/ then "image/png"
      when /\.gif$/ then "image/gif"
      when /\.(jpeg|jpg)$/ then "image/jpeg"
      when /\.svg$/ then "image/svg+xml"
      else "text/html"
      end
    end
end
