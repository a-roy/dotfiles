#!/usr/bin/env python
import i3ipc
import subprocess

if __name__ == '__main__':
    i3 = i3ipc.Connection()
    win_id = i3.get_tree().find_focused().window
    # splith fallback
    cmd = 'splith'
    if win_id:
        result = subprocess.run(['wmctrl', '-l', '-G'], stdout=subprocess.PIPE)
        line = [l for l in result.stdout.decode().split('\n')
                if l.startswith('{0:#010x}'.format(win_id))]
        # in case something went wrong
        if len(line) > 0:
            dims = [int(d) for d in line[0].split()[4:6]]
            if dims[0] < dims[1]:
                cmd = 'splitv'
    i3.command(cmd)
