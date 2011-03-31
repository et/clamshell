# Clamshell

Clamshell is a tool that converts generic shell statements into shell specific
statements that can be sourced to set up an environment.

## Motivation

While working on a legacy project that used tcsh as its primary shell, I wanted
to use bash, but realized that some of the old schoolers actually liked tcsh.
This was the compromise.

## Requirements

* [ruby](http://www.ruby-lang.org/en/downloads/) 1.9.2

## Installing

Clone the repository

    git clone git://github.com/et/clamshell.git

##  Setting up an environment file

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

#### Pitfall

Another approach you might have considered is to generate multiple
files and source each one.

__DON'T!__

In tcsh, appending to an environment variable that doesn't exist throws an
error. There is an internal mechanism in clamshell that detects if an
environment variable doesn't exist. If it doesn't it creates one and sets
it to an empty string before appending.

So the previous example would generate the following statements:

    setenv CLASSPATH ""
    setenv CLASSPATH ${CLASSPATH}:~/java
    echo FOOBAR

This can cause some headaches if more than one file is generated.

*Rule of thumb: generate one file, source one file.*

### Conversion on the fly

If you need to convert a generic statement without using a file, you can
use the `convert_string` action, but you must specify a shell.

    clamshell convert_string "env_var 'FOO' 'BAR'" --shell=tcsh
    => setenv FOO BAR\n

## Todo

* Package as gem.
