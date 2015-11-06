echo source %CD%\vimrc>%HOMEDRIVE%%HOMEPATH%_vimrc
echo source %CD%\vimperatorrc>%HOMEDRIVE%%HOMEPATH%_vimperatorrc
xcopy /I %CD%\vimperator %HOMEDRIVE%%HOMEPATH%\.vimperator
