# Clamshell

Clamshell is a tool that validates your project's dependencies in
a cross-shell compatible environment.

## Requirements

* [ruby](http://www.ruby-lang.org/en/downloads/) 1.9.2
* [bundler](http://gembundler.com/)
* [git](http://git-scm.com/download) > 1.7.2

## Installing

Clone the repository

    git clone git://github.com/et/clamshell.git

Install the required gems using `bundler`.

    bundle install

## Dependency file

In your project root directory, set up a file called `Dependencies.list`:

    Dependencies.validate do
      git "/path/to/git/repo", :ref => "12345SHAID"
    end

In plain English, this says: "The project, `MyProject` has one dependency to a git
repository located at `/path/to/git/repo` whose `HEAD` must be pointing to `12345SHAID`".
This assumes that the directory contains a `.git` directory.

You can check a dependencies file:

    clamshell check Dependencies.list

which will validate whether or not the listed dependencies are up to date.

##  Environment file

Sometimes your project has a dependency that is shell specific (environment variables,
aliases). Setup a `SHELL.env` file in your project root with the following:

    Environment.setup ("bash") do
      env_var "DISTCC_HOSTS" "localhost red green blue"
      env_var "PATH", :prepend => "~/bin",    :delimiter => ":"
      env_var "PATH", :append  => "/usr/bin", :delimiter => ":"
      alias editor "vim"
    end

You can convert these statements to bash statements as follows:

    clamshell convert SHELL.env

which will print the following to standard out:

    export DISTCC_HOSTS='localhost red green blue'
    export PATH=~/bin:$PATH
    export PATH=$PATH:/usr/bin
    alias editor='vim'

You also do not have specify a shell:

    environment.setup do
      ...
      ...
    end

But you must pass the flag `--shell=SHELLNAME`.
Best practices for multi-shell environments use the following command:

    --shell=`ps -p $$ | awk 'NR==2 {print $4}'`

which will set the shell flag to the type of shell currently being ran.

Currently, the shells supported are tcsh and bash. However, I am assuming that
csh and zsh are supported as well since they are closely related to tcsh and
bash, respectively. Hence, aliases are set up for their respective shells.


## Options

### Boolean options

* `--no-color`       - Disables color
* `--disable`        - Disables clamshell from running (useful if you use clamshell in some kind of continuous integration)
* `--verbose`        - Prints debugging information.
* `--git_auto_reset` - Attempts to `git reset` each of the git repositories to the requested revision. (FIXME)
* `--git_auto_pull`  - Attempts to `git pull` each of the git repositories' origins. (FIXME)

### String options

* `--shell=SHELLNAME` - The environment section will generate shell statements for `SHELLNAME`. This is required if a shell name is not specified in your environment section.
* `--shell_out=SHELL_OUT.txt` - Pipe the generated shell statements to a file. (FIXME)

### Settings

All of the above options can be localized to a settings file. To do so, set
up a file called `settings.yml` and invoke `clamshell` as follows.

     % clamshell check Dependencies.list --settings=/path/to/settings.yml

Any flags used on the command line will override what is in `settings.yml` file.
Refer to the spec fixtures for a full
[example](http://github.com/et/clamshell/blob/master/spec/fixtures/settings.yml)
of `settings.yml`.


## Todo

* More git options -- reference more than SHA_ids (branch, tag, etc.)
* Setting an environment variable should set some kind of internal environment variable as well.
* If the output it to be sourced then use echo statements
* Check if apps exist in user's PATH.
* Throw error status code if a dependency is not fulfilled.
* shell_out flag implementation.
