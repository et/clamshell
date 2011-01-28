A work in progress, adding a [README](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html).

# Clamshell

Clamshell is a tool that manages project depenencies in a generic application.
Inspired by the [bundler](http://gembundler.com), this tool attempts to do
mitigate the dependency management that comes along with distributing a
project.

## Setting up a project dependency file

In your project root directory, set up a file called `Dependencies.list`:

    Dependencies.configure do
      project "YourProjectName"

      git "/path/to/git/repo.git", :ref => "12345SHAID"
    end


## Usage

Run `clamshell` over your `Dependencies.list` file you just created.

    % clamshell check Dependencies.list

It should print out the list of dependencies. Dependencies up to date
are in green, otherwise they are listed in red.

### Options

    --no-color - Disables color (but how can you tell the difference
                                 between good/bad dependencies???)
    --disable  - Disables clamshell from running (useful if you use clamshell
                                                  in some kind of continuous
                                                  integration)
    --verbose  - Prints debugging information.

### Configuration

You may also customize `clamshell` to be more useful. To do so, set up a file
called `settings.yml`.

     git_auto_load: true   # Automatically checks out git repos to the requested state.

To use your configuration file, run `clamshell` as follows:

     % clamshell check Dependencies.list --settings=/path/to/settings.yml
