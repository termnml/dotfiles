#!/bin/bash

SET_SYMLINK () {     
  # returns if symlink was created and action_after should be called     
  if [[ $1 == "foo" ]]; then
    echo "symlink_created"
  fi
}     

if [[ "$(SET_SYMLINK "foo")" == "symlink_created" ]]; then
	echo "foo"
fi
