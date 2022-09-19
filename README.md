# sh-argparse

Argument parser for shell functions

## About

This is a function of only 30 lines that provides minimal argument parsing for shell functions.

It should work with dash, bash, ksh, mksh, yash, zsh and **all POSIX-compliant shells**. And it is implemented using only the shell, with **no external commands**.

## Usage Examples

```sh
#!/bin/sh

set -eu
. ./argparse.sh

func() {
  name1=false name2= arg1= arg2= # Make it local variables if you want.
  argparse --name1 --name2= :arg1 :arg2 : "$@" || shift $?

  # Note: `argparse --long-name-with-hyphon value ...` allows assignment
  # to a variable with a different name.
  # The `:` is required to distinguish it from the argument to be parsed.

  echo "name1: $name1, name2: $name2" # => name1: true, name2: abc
  echo "arg1: $arg1, arg2: $arg2" # => arg1: 1, arg2: 2
  echo "rest arguments: " "$@" # => rest arguments: 3 4 5
}

func --name1 --name2=abc 1 2 3 4 5
# Note: "--name value" style is not supported.
```

## Technical Details

argparse dynamically generates and executes code for argument parsing.

```sh
func() {
  name1=false name2= arg1= arg2= # Make it local variables if you want.

  # argparse -name1 value1 -name2= value2 :arg1 :arg2 : "$@" || shift $?
  #   It dynamically generates the following code.
  while [ $# -gt 0 ]; do
    case $1 in
      --) shift && break ;;
      --name1) name1=true ;;
      --name2=*) name2=${1#*=} ;;
      -*) echo "argparse: unknown option: ${1%%=*}" >&2 && exit 1 ;;
      *) break ;;
    esac
    shift
  done
  arg1=$1 && shift
  arg2=$1 && shift

  echo "name1: $name1, name2: $name2" # => name1: true, name2: abc
  echo "arg1: $arg1, arg2: $arg2" # => arg1: 1, arg2: 2
  echo "rest arguments: " "$@" # => rest arguments: 3 4 5
}
```

## License

[Creative Commons Zero v1.0 Universal](https://github.com/ko1nksm/sh-argparse/blob/master/LICENSE)

All rights are relinquished and you can used as is or modified in your project.
No credit is also required, but I would appreciate it if you could credit me as the original author.
