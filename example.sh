#!/bin/sh

set -eu
. ./argparse.sh

func() {
  name1=false name2= lname= arg1= arg2= # Make it local variables if you want.
  argparse --name1 --name2= --long-name= lname :arg1 :arg2 : "$@" || shift $?

  echo "name1: $name1, name2: $name2" # => name1: true, name2: abc
  echo "long name: $lname"            # => long name: value
  echo "arg1: $arg1, arg2: $arg2"     # => arg1: 1, arg2: 2
  echo "rest arguments: " "$@"        # => rest arguments: 3 4 5
}

func --name1 --name2=abc --long-name=value -- 1 2 3 4 5
# Note: "--name value" style is not supported.
