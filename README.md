A work in progress, adding a [README](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html).

# Spider

Spider is a tool that manages project depenencies in a generic application.
Inspired by the [bundler](http://gembundler.com), this tool attempts to do
mitigate the dependency management that comes along with distributing a
project.

## Setting up a project dependency file

In your project root directory, set up a file called `Dependencies.list`:

    Dependencies.configure do
      project "YourProjectName"

      dependency :type => "git",
                 :ref  => "12345SHAID"
                 :path => "/path/to/git/repo.git"
    end


## Usage

Run `spider` over your `Dependencies.list` file you just created.

    % spider check Dependencies.list

It should print out the list of dependencies. Dependencies up to date
are in green, otherwise they are listed in red.

### Options

    --no-color - Disables color (but how can you tell the difference
                                 between good/bad dependencies???)
    --disable  - Disables spider from running (useful if you use
                                               spider in some kind of
                                               incremental fashion)
    --verbose  - Prints debugging information.

### Configuration

You may also customize `spider` to be more useful. To do so, set up a file
called `settings.yml`.

     git_auto_load: true   # Automatically checks out git repos to the requested state.

To use your configuration file, run `spider` as follows:

     % spider check Dependencies.list --settings=/path/to/settings.yml
