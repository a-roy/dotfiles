import subprocess

def read_xresources(prefix=''):
    props = {}
    x = subprocess.run(['xrdb', '-query'], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split('\n')
    for line in filter(lambda l : l.startswith(prefix), lines):
        prop, _, value = line.partition(':\t')
        props[prop] = value
    return props

def set_commands():
    esc = ' ;; '.join(['clear-keychain',
                       'clear-messages',
                       'jseval -q document.activeElement.blur()',
                       'search',
                       'fullscreen --leave'])
    config.unbind('d', mode='normal')
    commands_normal = {
        '<escape>': esc,
        '<ctrl+e>': 'scroll-px 0 40',
        '<ctrl+y>': 'scroll-px 0 -40',
        'dd':       'tab-close -n',
        'D':        'tab-close -p',
        'gt':       'tab-focus',
        'gT':       'tab-prev',
        'gM':       'tab-move -1',
        'T':        'set-cmd-text -s :buffer',
        'xt':       'config-cycle tabs.show multiple never',
        'xx':       'config.cycle statusbar.hide ;; config-cycle tabs.show multiple never',
        '0':        'fake-key <home>',
        '^':        'fake-key <home>',
        '$':        'fake-key <end>',
        '<alt+[>':  'fake-key <escape>',
        ';i':       'hint images run open {hint-url}',
        ';I':       'hint images run open -t -r {hint-url}',
        ',m':       'spawn mpv {url}',
        ';M':       'hint --rapid links spawn umpv {hint-url}',
        ';m':       'hint links spawn umpv {hint-url}',
    }
    commands_normal_discord = {
        '<alt+j>':       'fake-key <alt+down>',
        '<alt+k>':       'fake-key <alt+up>',
        '<alt+l>':       'fake-key <ctrl+alt+right>',
        '<alt+n>':       'fake-key <ctrl+alt+down>',
        '<alt+p>':       'fake-key <ctrl+alt+up>',
        '<alt+shift+j>': 'fake-key <alt+shift+down>',
        '<alt+shift+k>': 'fake-key <alt+shift+up>',
        '<alt+shift+z>': 'fake-key <ctrl+shift+alt+up>',
        '<alt+z>':       'fake-key <ctrl+shift+alt+down>',
    }
    for k, v in commands_normal.items():
        config.bind(k, v, mode='normal')
    for k, v in commands_normal_discord.items():
        config.bind(k, v, mode='normal')
    commands_command = {
        '<ctrl+d>':  'rl-delete-char',
        '<ctrl+/>':  'completion-item-del',
        '<alt+x>':   'completion-item-del',
    }
    for k, v in commands_command.items():
        config.bind(k, v, mode='command')
    commands_insert = {
        '<alt+b>':        'fake-key <ctrl+left>',
        '<alt+f>':        'fake-key <ctrl+right>',
        '<ctrl+a>':       'fake-key <home>',
        '<ctrl+b>':       'fake-key <left>',
        '<ctrl+d>':       'fake-key <delete>',
        '<ctrl+e>':       'fake-key <end>',
        '<ctrl+f>':       'fake-key <right>',
        '<ctrl+h>':       'fake-key <backspace>',
        '<ctrl+k>':       'fake-key <shift+end> ;; fake-key <delete>',
        '<ctrl+n>':       'fake-key <down>',
        '<ctrl+o>':       'set-cmd-text :',
        '<ctrl+p>':       'fake-key <up>',
        '<ctrl+shift+a>': 'fake-key <ctrl+a>',
        '<ctrl+u>':       'fake-key <shift+home> ;; fake-key <backspace>',
        '<ctrl+w>':       'fake-key <ctrl+backspace>',
        '<Return>':       'fake-key <Enter>',
        '<ctrl+shift+e>': 'open-editor',
    }
    for k, v in commands_insert.items():
        config.bind(k, v, mode='insert')
    config.bind('<shift+insert>', 'fake-key <ctrl+v>', mode='passthrough')
    c.aliases = {
        'noh': 'search',
        'q': 'close'
    }

def set_colors():
    c.colors.statusbar.url.success.https.fg = 'chartreuse'
    bg_select = c.colors.completion.item.selected.bg
    c.colors.completion.item.selected.border.bottom = bg_select
    c.colors.completion.item.selected.border.top = bg_select

    # Xresources colors
    resources = read_xresources('user.color.')
    if not resources:
        return

    bg_normal = resources['user.color.bg-normal']
    fg_normal = resources['user.color.fg-normal']
    fg_emph = resources['user.color.fg-emph']
    bg_focus = resources['user.color.bg-focus']
    bg_compl = 'white'
    c.colors.tabs.odd.fg = fg_normal
    c.colors.tabs.odd.bg = bg_normal
    c.colors.tabs.even.fg = fg_normal
    c.colors.tabs.even.bg = bg_normal
    c.colors.tabs.selected.odd.bg = bg_focus
    c.colors.tabs.selected.even.bg = bg_focus
    c.colors.tabs.selected.odd.fg = fg_emph
    c.colors.tabs.selected.even.fg = fg_emph
    c.colors.tabs.bar.bg = 'black'
    c.colors.prompts.bg = bg_normal
    c.colors.completion.category.fg = fg_emph
    c.colors.completion.category.bg = bg_normal
    c.colors.completion.category.border.top = bg_normal
    c.colors.completion.category.border.bottom = bg_normal
    c.colors.completion.fg = bg_normal
    c.colors.completion.odd.bg = bg_compl
    c.colors.completion.even.bg = bg_compl
    c.colors.completion.scrollbar.fg = bg_normal
    c.colors.completion.scrollbar.bg = bg_compl

def set_fonts():
    guifont = '7.5pt Monospace'
    c.fonts.monospace = '"Roboto Mono", '+ c.fonts.monospace
    c.fonts.completion.category = 'bold {}'.format(guifont)
    c.fonts.completion.entry = guifont
    c.fonts.debug_console = guifont
    c.fonts.downloads = guifont
    c.fonts.keyhint = guifont
    c.fonts.messages.error = guifont
    c.fonts.messages.info = guifont
    c.fonts.messages.warning = guifont
    c.fonts.statusbar = guifont
    c.fonts.tabs = guifont
    c.fonts.hints = 'bold {}'.format(guifont)
    c.fonts.web.size.default_fixed = 14
    c.fonts.web.size.minimum = 14

def set_metrics():
    c.tabs.indicator_padding = {
        'bottom': 0,
        'left': 0,
        'right': 2,
        'top': 0,
    }
    c.tabs.padding = {
        'bottom': 0,
        'left': 0,
        'right': 2,
        'top': 0,
    }
    c.tabs.width.bar = 192
    c.tabs.width.indicator = 6
    c.tabs.position = 'left'
    c.tabs.show = 'multiple'
    c.downloads.position = 'bottom'
    c.tabs.title.format_pinned = '{index}| {title}'

def set_behavior():
    c.completion.quick = False
    c.tabs.background = True
    c.hints.scatter = False
    c.hints.chars = 'hjklasdfgyuiopqwertnmzxcvb'
    c.input.forward_unbound_keys = 'all'
    c.editor.command = ['termite', '-e', 'vim "{}"']
    c.tabs.last_close = 'close'
    c.tabs.select_on_remove = 'last-used'

if __name__ == 'config':
    set_commands()
    set_colors()
    set_fonts()
    set_metrics()
    set_behavior()
    c.content.host_blocking.whitelist.append('s.youtube.com')
    c.content.plugins = True
    c.content.user_stylesheets = ['/data/Aneesh/qutebrowser/user-stylesheet.css']
    c.url.searchengines['nyaa'] = 'https://nyaa.si/?f=0&c=0_0&q={}'
    c.url.searchengines['yt'] = (
        'https://www.youtube.com/results?search_query={}')
