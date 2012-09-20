#!/usr/bin/env ruby
$:.unshift('lib')
require 'redmine_plugin_support'
require 'chili_presentations'
require 'tasks/contributor_tasks'
require 'tasks/chili_presentations_tasks'

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_chili_presentations'
  plugin.default_task = [:test]
  plugin.tasks = [:db, :doc, :release, :clean, :test]
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end

Dir["/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default => [:test]

ChiliPresentationsTasks.new

begin
  require 'hoe'
  Hoe.plugin :git

  $hoe = Hoe.spec('chili_presentations') do
    developer('Tom Kersten', 'tom@whitespur.com')

    self.readme_file      = 'README.md'
    self.version          = ChiliPresentations::VERSION
    self.extra_rdoc_files = FileList['README.md', 'LICENSE', 'History.txt']
    self.summary = "ChiliProject (/Redmine) plugin which makes it easy to upload an HTML-presentation and associate it with a project. The plugin adds 'Presentations' tab to a project site which contains any associated presentations."
    self.extra_deps       = [
                              ['friendly_id', '3.2.1.1']
                            ]
  end

  ContributorTasks.new
rescue LoadError
  puts "You are missing the 'hoe' gem, which is used for gem packaging & release management."
  puts "Install using 'gem install hoe' if you need packaging & release rake tasks."
end
