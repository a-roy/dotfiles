#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by inserting them into WINDOW_ICONS below.
#
# Dependencies
# * xorg-xprop - install through system package manager
# * i3ipc - install with pip
#
# Installation:
# * Download this script and place it in ~/.config/i3/ (or anywhere you want)
# * Add "exec_always ~/.config/i3/i3-autoname-workspaces.py &" to your i3 config
# * Restart i3: "$ i3-msg restart"
#
# Configuration:
# The default i3 config's keybingings reference workspaces by name, which is an
# issue when using this script because the names are constantaly changing to
# show window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1


import i3ipc
import subprocess as proc
import re
import signal
import sys
from winicon import icon_for_window


i3 = i3ipc.Connection()

# renames all workspaces based on the windows present
def rename():
    for workspace in i3.get_tree().workspaces():
        if workspace.num < 0:
            continue
        icons = list(filter(None, [icon_for_window(w.window) for w in workspace.leaves()]))
        icon_str = ': ' + ' '.join(icons) if len(icons) else ''
        new_name = str(workspace.num) + icon_str
        i3.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))

rename()

# exit gracefully when ctrl+c is pressed
def signal_handler(signal, frame):
    # rename workspaces to just numbers on exit to indicate that this script is
    # no longer running
    for workspace in i3.get_tree().workspaces():
        if workspace.num < 0:
            continue
        i3.command('rename workspace "%s" to "%d"' % (workspace.name, workspace.num))
    i3.main_quit()
    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

# call rename() for relevant window events
def on_change(i3, e):
    if e.change in ['new', 'close', 'move', 'title']:
        rename()
i3.on('window', on_change)
i3.main()
