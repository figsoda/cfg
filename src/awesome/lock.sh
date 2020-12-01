#!/bin/sh

xss-lock -l --\
    i3lock-color -i ~/.config/wallpaper/resized.png\
    --indicator -k\
    --insidevercolor=202024 --insidewrongcolor=202024 --insidecolor=202024\
    --ringvercolor=98c040 --ringwrongcolor=d02828 --ringcolor=2060a0\
    --linecolor=00000000 --keyhlcolor=c06080 --bshlcolor=d06020\
    --verifcolor=b8f080 --wrongcolor=ff8080 --separatorcolor=00000000\
    --indpos=x+w/8:y+h-w/8\
    --timecolor=80d0f0 --time-font=monospace --timesize=30\
    --datecolor=f0c080 --datestr=%F --date-font=monospace --datesize=24\
    --veriftext=Verifying... --wrongtext="Try again!" --noinputtext="No input"\
    --locktext=Locking... --lockfailedtext="Lock failed!"\
    --ring-width 8
