CM_MAX_CLIPS=20 CM_SELECTIONS=clipboard clipmenud &
mpd &
nm-applet &
thunar --daemon &
udiskie -s &
unclutter --timeout 3 &
volctl &
xinput set-prop "$(< ~/.config/mouse)" 'Coordinate Transformation Matrix' 3 0 0 0 3 0 0 0 1 &
xset -b &
xset m 0 0 &
xset s 900 900 &
xset dpms 900 900 900 &
xset r rate 400 32 &
xss-lock -l -- \
    i3lock-color -i ~/.config/wallpaper/resized.png \
    --indicator -k \
    --insidevercolor=202024 --insidewrongcolor=202024 --insidecolor=202024 \
    --ringvercolor=98c040 --ringwrongcolor=d02828 --ringcolor=2060a0 \
    --linecolor=00000000 --keyhlcolor=c06080 --bshlcolor=d06020 \
    --verifcolor=b8f080 --wrongcolor=ff8080 --separatorcolor=00000000 \
    --indpos=x+w/8:y+h-w/8 \
    --timecolor=80d0f0 --time-font=monospace --timesize=30 \
    --datecolor=f0c080 --datestr=%F --date-font=monospace --datesize=24 \
    --veriftext=Verifying... --wrongtext="Try again!" --noinputtext="No input" \
    --locktext=Locking... --lockfailedtext="Lock failed!" \
    --ring-width 8 &
exec awesome
