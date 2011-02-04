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

## Clamshell files

Clamshell takes two types of files:

* An environment file that contains a list of shell specific statements that should be `source`d for your project.
* A dependencies file that contains a list of dependencies required for your project.

Both of these files may have ruby code embedded in them.

##  Environment file

Sometimes your project has a dependency that is shell specific (environment variables,
aliases). Setup a `Shell.env` file in your project root with the following:

    Environment.setup ("bash") do
      env_var "DISTCC_HOSTS" "localhost red green blue"
      env_var "PATH", :prepend => "~/bin",    :delimiter => ":"
      env_var "PATH", :append  => "/usr/bin", :delimiter => ":"
      alias editor "vim"
    end

You can convert these statements to bash statements as follows:

    clamshell convert SHELL.env

which will print the following to standard out (or to a file using the `--shell-out=FILE` flag).

    export DISTCC_HOSTS="localhost red green blue"
    export PATH=~/bin:$PATH
    export PATH=$PATH:/usr/bin
    alias editor="vim"

### Shell independence

Your environment file doesn't even need to specify a shell:

    Environment.setup do
      ...
    end

But you must pass the flag `--shell=SHELLNAME`.
Best practices for multi-shell environments use the following command:

    --shell=`ps -p $$ | awk 'NR==2 {print $4}'`

which will set the shell flag to the type of shell currently being ran.

Currently, the shells supported are tcsh and bash. However, I am assuming that
csh and zsh are supported as well since they are closely related to tcsh and
bash, respectively. Hence, aliases are set up for their respective shells.


## Dependencies file

In your project root directory, set up a file called `Dependencies.list`:

    Dependencies.validate do
      git "/path/to/git/repoA", :rev => "12345SHAID"
    end

In plain English, this says: "This project has one dependency to a git
repository located at `/path/to/git/repo` whose `HEAD` must be pointing to `12345SHAID`".
This assumes that the directory contains a `.git` directory.

Valid options include `:rev => SHA_ID` and `:tag => TAG`.
The `master` branch is implied to be the `HEAD`, but you can use the `:branch => BRANCH`
option to specify otherwise.

You can check a dependencies file:

    clamshell check Dependencies.list

which will validate whether or not the listed dependencies are up to date.

Refer to the spec's fixtures for an [example](https://github.com/et/clamshell/blob/master/spec/fixtures/Dependencies.list).


## Global options

* `--no-color`       - Disables color
* `--disable`        - Disables clamshell from running (useful if you use clamshell in some kind of continuous integration)
* `--verbose`        - Prints debugging information.

## Best practices

To use clamshell effectively, it's best to first convert your environment file
to your all the required shells using it.

    clamshell convert Shell.env --shell-out=Shell.bash
    clamshell convert Shell.env --shell-out=Shell.tcsh

Then set up a file called `Project.clamshell` in your project root directory
that contains the following:

    source Shell.`ps -p $$ | awk 'NR==2 {print $4}'`
    clamshell check Dependencies.list

and call it with `source Project.clamshell`. This will source the correct shell
statements then check the dependencies.

## Todo

* More git options -- reference more than SHA_ids (branch, tag, etc.)
* Setting an environment variable should set some kind of internal environment variable as well.
* If the output it to be sourced then use echo statements
* Check if apps exist in user's PATH.
* Throw error status code if a dependency is not fulfilled.
* shell_out flag implementation.
* Make clamopts file.
