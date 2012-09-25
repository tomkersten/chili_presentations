require 'rake'
require 'rake/tasklib'

class ChiliPresentationsTasks < Rake::TaskLib
  VALID_DJ_ACTIONS = %w(start restart stop status)

  def initialize
    define
  end

  def define
    namespace :chili_presentations do
      desc "Install ChiliPresentations plugin (migrate database, include assets, etc)"
      task :install => [:migrate_db, :symlink_assets]

      desc "Uninstalls ChiliPresentations plugin (removes database modifications, removes assets, etc)"
      task :uninstall => [:environment] do
        puts "Removing ChiliPresentations database modifications..."
        migrate_db(:to_version => 0)

        puts "Removing link to ChiliPresentations assets (stylesheets, js, etc)..."
        remove_symlink asset_destination_dir
        puts post_uninstall_steps
      end

      task :migrate_db => :environment do
        puts "Migrating chili_presentations..."
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate(gem_db_migrate_dir, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end

      task :symlink_assets => [:environment] do
        # HACK: Symlinks the files from plugindir/assets to the appropriate place in
        # the rails application
        puts "Symlinking assets (stylesheets, etc)..."
        add_symlink asset_source_dir, asset_destination_dir
      end
    end
  end

  private
    def application_root
      File.expand_path(RAILS_ROOT)
    end

    def gem_root
      @gem_root ||= File.expand_path(File.dirname(__FILE__) + "/../..")
    end

    def asset_destination_dir
      @destination_dir ||= File.expand_path("#{application_root}/public/plugin_assets/chili_presentations")
    end

    def asset_source_dir
      @source_dir ||= File.expand_path(gem_root + "/assets")
    end

    def remove_symlink(symlink_file)
      system("unlink #{symlink_file}") if File.exists?(symlink_file)
    end

    def add_symlink(source, destination)
      remove_symlink destination
      system("ln -s #{source} #{destination}")
    end

    def gem_db_migrate_dir
      @gem_db_migrate_dir ||= File.expand_path(gem_root + "/db/migrate")
    end

    def migrate_db(options = {})
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate(gem_db_migrate_dir, options[:to_version])
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    def post_uninstall_steps
      [
        "!!!!! MANUAL STEPS !!!!!",
        "\t1. In your 'Gemfile', remove:",
        "\t\tgem 'chili_presentations'",
        "",
        "\t2. In your 'Rakefile', remove:",
        "\t\trequire 'tasks/chili_presentations_tasks'",
        "",
        "\t3. Run 'bundle' (or 'bundle install') to update your Gemfile.lock",
        "",
        "\t4. Cycle your application server (mongrel, unicorn, etc)",
        "\n",
      ].join("\n")
    end
end

ChiliPresentationsTasks.new
