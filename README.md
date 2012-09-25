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
1. This plugin must be deployed behind the nginx web server, or a server which
   implements the same `X-Sendfile` behavior as nginx (none that I am aware of
   do this). The controller which serves up the presentation defers this task
   to nginx by setting the `X-Accel-Redirect` header. If ChiliProject is
   deployed behind anything other than nginx, it is likely you will only be
   shown a blank screen. (__NOTE:__ This could easily be changed, but there is
   no reason in my environment to support other servers. Patches are absolutely
   welcome.)
1. You must be able to set up a simple directive in your nginx config and cycle
   nginx in order to take advantage of the afforementioned `X-Accel-Redirect`
   header feature of nginx.

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
  - paperclip (v2.7.0)

* System commands:
  - `unzip` must be installed and on the path of the user running the
    ChiliProject application servers.

## INSTALL:

### In nginx

Add the following block to your ChiliProject nginx config (inside your `server`
block):

```
location ~ /contents/ {
  # NOTE: Below, `root` is NOT set to `RAILS_ROOT/public`!
  root RAILS_ROOT/uploaded_presentations;
  internal;
}
```

Cycle `nginx`.

### In ChiliProject

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

``` ruby
require 'tasks/chili_presentations_tasks'
```

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

In your 'Rakefile', remove:

``` ruby
require 'tasks/chili_presentations_tasks'
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
