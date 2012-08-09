#!/bin/bash
# Usage: add-to-path [DIRNAME]
# Author: Weston Ruter (@westonruter) <http://weston.ruter.net/>
# URL: https://github.com/westonruter/misc-cli-tools/blob/master/add-to-path
#
# Bash function to prepend the current working directory or the path supplied
# (as the first argument) to the PATH environment variable in the current sesson.
# source this file in your .profile, e.g.:
# source ~/bin/functions/add-to-path.sh

function add-to-path {
  if [ $# == 0 ]; then
    dir=`pwd`
  else
    cd $1
    dir=`pwd`
    cd - > /dev/null 2>&1
  fi

  PATH="$dir:$PATH"
  export PATH
  echo $PATH
}
