require 'fileutils'
require 'tmpdir'
require 'find'

class PresentationObserver < ActiveRecord::Observer
  def after_save(presentation)
    Rails.logger.info "Executing PresentationObserver after_save hook (#{__FILE__}:#{__LINE__})"

    # location of existing compressed (zipped) file
    compressed_file = presentation.contents.path

    # Converts /.../path/original/something.zip -> /.../path/original/unpacked/
    destination_path = File.join(File.dirname(presentation.contents.path),
                                 Presentation::UNPACKED_DIRNAME)

    Dir.mktmpdir {|tmpdir_path|
      Rails.logger.info "Temporarily unpacking presentation into #{tmpdir_path}"
      Paperclip.run("unzip", "#{compressed_file} -d #{tmpdir_path}")

      index_container = Find.find(tmpdir_path) do |file|
        break File.dirname(file) if file =~ /index\.html/
      end

      if index_container.blank?
        Rails.logger.warn "No index.html file found in uploaded zipfile for presentation with ID of #{presentation.id}! Skipping."
      else
        # move index-containing directory to one named
        # Presentation::UNPACKED_DIRNAME, regardless of original name/structure
        Rails.logger.info "Moving #{index_container} to #{destination_path}"
        FileUtils.move index_container, destination_path
      end
      Rails.logger.info "Uncompressing uploaded presentation completed successfully."
    }
  end

  def after_destroy(presentation)
    Rails.logger.info "Executing PresentationObserver after_destroy hook (#{__FILE__}:#{__LINE__})"
    Paperclip.run("rm", "-rf #{File.dirname presentation.unzipped_location}")
    Rails.logger.info "Cleaned up all unzipped files from #{presentation.unzipped_location}"
  end
end
