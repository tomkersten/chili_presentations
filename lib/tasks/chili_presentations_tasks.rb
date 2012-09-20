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
      task :install => [:migrate_db]

      desc "Uninstalls ChiliPresentations plugin (removes database modifications, removes assets, etc)"
      task :uninstall => [:environment] do
        puts "Removing ChiliPresentations database modifications..."
        migrate_db(:to_version => 0)

        puts "Removing link to ChiliPresentations assets (stylesheets, js, etc)..."
      end

      task :migrate_db => [:environment] do
        puts "Migrating chili_presentations..."
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate(gem_db_migrate_dir, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
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

    def gem_db_migrate_dir
      @gem_db_migrate_dir ||= File.expand_path(gem_root + "/db/migrate")
    end

    def migrate_db(options = {})
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate(gem_db_migrate_dir, options[:to_version])
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

#    def post_uninstall_steps
#      [
#        "!!!!! MANUAL STEPS !!!!!",
#        "\t1. In your 'config/environment.rb', remove:",
#        "\t\tconfig.gem 'chili_videos'",
#        "",
#        "\t2. In your 'Rakefile', remove:",
#        "\t\trequire 'chili_videos'",
#        "\t\trequire 'tasks/chili_videos_tasks'",
#        "\t\tChiliVideosTasks.new",
#        "",
#        "\t3. Cycle your application server (mongrel, unicorn, etc)",
#        "\n",
#      ].join("\n")
#    end
end

ChiliPresentationsTasks.new
