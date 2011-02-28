# Clamshell

Clamshell is a tool that validates your project's dependencies in
a cross-shell compatible environment.

## Requirements

* [ruby](http://www.ruby-lang.org/en/downloads/) 1.9.2
* [bundler](http://gembundler.com/) ~> 1.0

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
      env_var "LC_CTYPE", "en_US"
      env_var "PATH", :prepend => "~/bin",    :delimiter => ":"
      env_var "PATH", :append  => "/usr/bin", :delimiter => ":"
      env_alias editor "vim"
    end

You can convert these statements to bash statements as follows:

    clamshell convert SHELL.env

which will print the following to standard out (or to a file using the `--shell-out=FILE` flag).

    export LC_CTYPE=en_US
    export PATH=~/bin:$PATH
    export PATH=$PATH:/usr/bin
    alias editor=vim

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

### Generic shell statements

You can also call generic shell statements that are valid in all shells:

    echo -n FOO

But you must be verbose that you are doing so:

    cmd "echo -n FOO"

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

Additionally, you can use a `:ignored => true` option to skip validation for this dependency.

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

### Unique shell statements

If you need to setup the environment and produce a shell command that is
different depending on the shell being used, the global variable `$SHELL`
is available:

    Environment.setup do
      if $SHELL == "tcsh"
        cmd "unlimit coredumpsize"
      elsif $SHELL == "bash"
        cmd "ulimit -c unlimited"
      end
    end

### Splitting the environment

If you want to split your environment files up, the `include_file` command
is as your disposal.

    Environment.setup do
      include_file "/path/to/another.file"
    end

`another.file`'s contents:

    env_var "CLASSPATH", :append => "~/java"
    cmd "echo FOOBAR"

If you definitely need to split your environment up, take this approach.
Another approach you might have considered is to create multiple generated
files and source each one.

DON'T!

In tcsh, appending to an environment variable that doesn't exist throws an
error. There is an internal mechanism in clamsehll that detects if an
environment variable doesn't exist. If it doesn't it creates one and sets
it to an empty string before appending.

So the previous example would generate the following statements in tcsh:

    setenv CLASSPATH ""
    setenv CLASSPATH ${CLASSPATH}:~/java
    echo FOOBAR

### Conversion on the fly

If you need to convert a generic statement without using a file, you can
use the `convert_string` action, but you must specify a shell.

    clamshell convert_string "env_var 'FOO' 'BAR'" --shell=tcsh
    => setenv FOO BAR\n

## Todo
* Make clamopts file.
* Split this project.
