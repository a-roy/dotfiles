#!/usr/bin/env bash

if (( $# > 0 ))
then
	i3-msg "move container to workspace $*">/dev/null
else
	i3-workspaces
fi
