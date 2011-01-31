A work in progress, adding a [README](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html).

# Clamshell

Clamshell is a tool that manages project depenencies in a generic application.
Inspired by the [bundler](http://gembundler.com), this tool attempts to do
mitigate the dependency management that comes along with distributing a
project.

## Requirements

* [ruby](http://www.ruby-lang.org/en/downloads/) 1.9.2
* [bundler](http://gembundler.com/)
* [git](http://git-scm.com/download) > 1.7.2

## Installing

Clone the repository

    git clone git://github.com/et/clamshell.git

Install the required gems using `bundler`.

    bundle install

## Setting up a project dependency file

In your project root directory, set up a file called `Dependencies.list`:

    Project.configure "MyProject" do
      git "/path/to/git/repo.git", :ref => "12345SHAID"
    end

In plain English, this says: "The project, `MyProject` has one dependency to a git
repository located at `/path/to/git/repo.git` whose `HEAD` must be pointing to `12345SHAID`"

###  Environment section

Sometimes your project has a dependency that is shell specific. You can set it
up as follows:

    Project.configure ("MyProject") do
      environment("bash") do
        env_var "DISTCC_HOSTS" "localhost red green blue"

        env_var "PATH", :prepend => "~/bin", :delimiter => ":"
        env_var "PATH", :append  => "~/usr/bin", :delimiter => ":"

        alias editor "vim"
      end
    end

When run, this will print the following to standard out (or to a file using the `--shell-out=SHELL_OUT.txt` flag).

    export DISTCC_HOSTS='localhost red green blue'
    export PATH=~/bin:$PATH
    export PATH=$PATH:~/usr/bin
    alias editor='vim'

You also do not have specify a shell:

    environment do
      ...
      ...
    end

But you must pass the flag `--shell=SHELLNAME`.
Best practices for multi-shell environments can use the following command:

    --shell=`ps -p $$ | awk 'NR==2 {print $4}'`

which will set the shell flag to the type of shell currently being ran.

Currently, the shells supported are tcsh and bash. However, I am assuming that
csh and zsh are supported as well since they are closely related to tcsh and
bash, respectively. Hence, aliases are set up for their respective shells.

Refer to the spec fixtures for a full
[example](https://github.com/et/clamshell/blob/master/spec/fixtures/Dependencies.list)
of `Dependencies.list`.


## Usage

Run `clamshell` over your `Dependencies.list` file you just created.

    % clamshell check Dependencies.list

It should print out the list of dependencies. Dependencies up to date
are in green, otherwise they are listed in red.

### Options

#### Boolean options

* `--no-color`       - Disables color
* `--disable`        - Disables clamshell from running (useful if you use clamshell in some kind of continuous integration)
* `--verbose`        - Prints debugging information.
* `--git_auto_reset` - Attempts to `git reset` each of the git repositories to the requested revision.
* `--git_auto_pull`  - Attempts to `git pull` each of the git repositories' origins.

#### String options

* `--shell=SHELLNAME` - The environment section will generate shell statements for `SHELLNAME`. This is required if a shell name is not specified in your environment section.
* `--shell-out=SHELL_OUT.txt` - Pipe the generated shell statements to a file.

#### Settings

All of the above options can be localized to a settings file. To do so, set
up a file called `settings.yml` and invoke `clamshell` as follows.

     % clamshell check Dependencies.list --settings=/path/to/settings.yml

Any flags used on the command line will override what is in `settings.yml` file.


## Todo

* More git options -- reference more than SHA_ids (branch, tag, etc.)
* Setting an environment variable should set some kind of internal environment variable as well.
