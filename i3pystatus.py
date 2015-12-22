#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess

from i3pystatus import Status

status = Status(standalone=True)

status.register("clock",
    format="\uf133 %Y-%m-%d \uf017 %T",)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
#status.register("load")

# Shows your CPU temperature, if you have a Intel CPU
#status.register("temp",
#    format="{temp:.0f}°C",)

status.register("battery",
    format="{status} {percentage_design:.2f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "\uf0e7",
        "CHR": "\uf1e6",
        "FULL": "\uf0e7",
    },)

status.register("network",
    interface="enp6s0",
    format_up="\uf038 {v4cidr}",
    format_down="",
    dynamic_color=True)

status.register("network",
    interface="wlp5s0f0",
    format_up="\uf1eb {quality:03.0f}% / {essid}",
    format_down="{essid}",
    dynamic_color=True)

status.register("disk",
    path="/",
    format="\uf0a0 {avail}G",
    critical_limit=5,)

status.register("alsa",
    format="{muted} {volume}%",
    muted="\uf026",
    unmuted="\uf028",)

status.register("mpd",
    format="{status} [{title} - {artist}] ({song_elapsed}/{song_length})",
    status={
        "pause": "\uf04c",
        "play": "\uf04b",
        "stop": "\uf04d",
    },)

status.run()
