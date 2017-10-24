#!/usr/bin/env python

import sys
import subprocess
import re

# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names and the icons can be any text you want to display. However
# most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
FA_ASTERISK = '\uf069'
FA_BOOK = '\uf02d'
FA_BUG = '\uf188'
FA_CHROME = '\uf268'
FA_CODE = '\uf121'
FA_COG = '\uf013'
FA_COMMENT_O = '\uf0e5'
FA_COMMENTS_O = '\uf0e6'
FA_CUBE = '\uf1b2'
FA_ENVELOPE_O = '\uf003'
FA_FILE_IMAGE_O = '\uf1c5'
FA_FILE_PDF_O = '\uf1c1'
FA_FILE_TEXT_O = '\uf0f6'
FA_FILES_O = '\uf0c5'
FA_FILM = '\uf008'
FA_FIREFOX = '\uf269'
FA_FOLDER_OPEN_O = '\uf115'
FA_GAMEPAD = '\uf11b'
FA_GLOBE = '\uf0ac'
FA_HASHTAG = '\uf292'
FA_MUSIC = '\uf001'
FA_PAINT_BRUSH = '\uf1fc'
FA_PENCIL_SQUARE_O = '\uf044'
FA_PICTURE_O = '\uf03e'
FA_PLAY_CIRCLE_O = '\uf01d'
FA_REDDIT_ALIEN = '\uf281'
FA_SKYPE = '\uf17e'
FA_STEAM = '\uf1b6'
FA_STICKY_NOTE_O = '\uf24a'
FA_TERMINAL = '\uf120'
FA_TWITCH = '\uf1e8'
FA_VIDEO_CAMERA = '\uf03d'
FA_YOUTUBE_PLAY = '\uf16a'
WINDOW_ICONS = {
    'Termite': FA_TERMINAL,
    'xterm': FA_TERMINAL,
    'mail.google.com__mail': FA_ENVELOPE_O,
    'mail.google.com__mail_u_0': FA_ENVELOPE_O,
    'mail.google.com__mail_u_1': FA_ENVELOPE_O,
    'chromium': FA_CHROME,
    'google-chrome': FA_CHROME,
    'Firefox': FA_FIREFOX,
    'qutebrowser': FA_GLOBE,
    'vimb': FA_GLOBE,
    'Gvim': FA_PENCIL_SQUARE_O,
    'Ario': FA_MUSIC,
    'libreoffice': FA_FILE_TEXT_O,
    'mpv': FA_PLAY_CIRCLE_O,
    'feh': FA_PICTURE_O,
    'Zathura': FA_FILE_TEXT_O,
    'nautilus': FA_FOLDER_OPEN_O,
    'qt5ct': FA_COG,
    'Pidgin': FA_COMMENT_O,
    'gimp-2.8': FA_PAINT_BRUSH,
    'Pinta': FA_PAINT_BRUSH,
    'inkscape': FA_PAINT_BRUSH,
    'Blender': FA_CUBE,
    'calibre-gui': FA_BOOK,
    'MComix': FA_FILE_IMAGE_O,
    'discord': FA_COMMENTS_O,
    'skype': FA_SKYPE,
    'Steam': FA_STEAM,
    'simplenote': FA_STICKY_NOTE_O,
    'streamlink-twitch-gui': FA_TWITCH,
    'LoLPatcherUx.exe': FA_GAMEPAD,
    'LolClient.exe': FA_GAMEPAD,
    'LeagueClientUx.exe': FA_GAMEPAD,
    'BsSendRpt.exe': FA_BUG,
    'tilda': '',
    'stjerm': '',
    'Galendae': ''
}
WINDOW_ICONS_RE = {
    # Note: ncmpcpp config must change `song_window_title_format` so that it can
    # be recognized while playing
    'Termite': [
        (re.compile(r'.* - N?VIM\d*'), FA_PENCIL_SQUARE_O),
        (re.compile(r'ranger:.*'), FA_FOLDER_OPEN_O),
        (re.compile(r'WeeChat( \d.\d)?'), FA_HASHTAG),
        (re.compile(r'(.* - )?ncmpcpp( \d\.\d)?'), FA_MUSIC),
        (re.compile(r'(.* - )?mpsyt'), FA_YOUTUBE_PLAY),
        (re.compile(r'(.* - )?rtv \d+\.\d+\.\d+'), FA_REDDIT_ALIEN)],
    'zathura': [
        (re.compile(r'.*\.pdf'), FA_FILE_PDF_O)],
    'mainwindow.py': [
        (re.compile(r'PlayOnLinux'), FA_GAMEPAD),
        (re.compile(r'PlayOnLinux configuration'), FA_COG)]
}


# Returns an array of the values for the given property from xprop.  This
# requires xorg-xprop to be installed.
def xprop(win_id, property):
    try:
        prop = subprocess.check_output(
                ['xprop', '-id', str(win_id), '8s', ' $0+', property],
                stderr=subprocess.DEVNULL)
        prop = prop.decode('utf-8')
        return re.findall(r'"((?:[^\\"]|\\\\|\\")*)"', prop)
    except subprocess.CalledProcessError as e:
        print("Unable to get property for window '%s'" % str(win_id),
                file=sys.stderr)
        return None

def icon_for_window(win_id):
    classes = xprop(win_id, 'WM_CLASS')
    if classes == None:
        return ''
    if len(classes) > 0:
        for cls in filter(lambda cls: cls in WINDOW_ICONS_RE, classes):
            title = xprop(win_id, 'WM_NAME')
            if not title:
                continue
            for exp, icon in WINDOW_ICONS_RE[cls]:
                if exp.fullmatch(title[0]) != None:
                    return icon
        for cls in classes:
            if cls in WINDOW_ICONS:
                return WINDOW_ICONS[cls]
        print('No icon available for window with classes: %s' % str(classes),
                file=sys.stderr)
    return FA_ASTERISK
