# ChiliPresentations - Host HTML-presentations in a ChiliProject installation

* http://github.com/tomkersten/chili_presentations

## DESCRIPTION:

ChiliProject/Redmine plugin which allows you to upload a zipped directory
containing a "web-friendly" presentation (HTML/JS/CSS) and associate it
with a project. The plugin will unzip it and filter viewing permissions
according to your 'permissions' settings.


## NOTABLE ITEMS TO CONSIDER

1. This plugin is distributed as a gem, but does
   ship with migrations and asset files (stylesheets, etc). Therefore,
   the installation procedure is not the standard process.

## FEATURES:

1. Makes it dead simple upload, store, and view HTML-based presentations
   within a ChiliProject/Redmine (CP/RM) installation.
1. Allows you to link presentations to specific "versions" in the CP/RM
   project
1. Adds a "presentation" wiki macro which can be used to link to a
   presentation in wikis, news items, et cetera.

## SYNOPSIS:

1. Install the plugin
1. Enable the "Presentations" module in a project

A "Presentations" tab will show up in your project. Click the "Add Presentation"
link in the contextual menu and use the form to upload a zipped directory
containing an @index.html@ file. The new presentation will show up in the list
of that project's presentations.

## REQUIREMENTS:

* Gems:
  - friendly\_id (v3.2.1.1)

## INSTALL:

```
gem install chili_presentations
```

### Manual steps after gem installation

In your 'Gemfile', add:

``` ruby
gem 'chili_presentations'
```

Execute `bundle install` (or `bundle update chili_presentations` if you had a
previous version installed).

Next, in your 'Rakefile', add:

Run the installation rake task (runs migrations)

```
RAILS_ENV=production rake chili_presentations:install
```

Cycle your application server (mongrel, unicorn, etc) and enable the module in
a project.


## UNINSTALL:

Run the uninstall rake task (reverts migrations)

```
RAILS_ENV=production rake chili_videos:uninstall
```

In your 'Gemfile', remove:

``` ruby
gem 'chili_presentations'
```

Cycle your application server (mongrel, unicorn, whatevs)...

Then, uninstall the chili_presentations gem:

```
gem uninstall chili_presentations
```

Done.

## CONTRIBUTING AND/OR SUPPORT:

### Found a bug? Have a feature request?

Please file a ticket on the '[Issues](https://github.com/tomkersten/chili_videos/issues)'
page of the Github project site

You can also drop me a message on Twitter [@tomkersten](http://twitter.com/tomkersten).
### Want to contribute?

(Better instructions coming soon)

1. Fork the project
1. Create a feature branch and implement your idea (preferably with tests)
1. Update the History.txt file in the 'Next Release' section (at the top)
1. Send a pull request

## LICENSE:

Refer to the [LICENSE](https://github.com/tomkersten/chili_presentations/blob/master/LICENSE) file
