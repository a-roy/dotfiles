#!/usr/bin/env bash

if (( $# > 0 ))
then
	i3-msg "workspace $*">/dev/null
else
	i3-workspaces
fi
