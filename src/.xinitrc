CM_MAX_CLIPS=20 CM_SELECTIONS=clipboard clipmenud &
mpd &
nm-applet &
thunar --daemon &
udiskie -s &
unclutter --timeout 3 &
volctl &
xset -b &
xss-lock -l -- \
    i3lock-color -i ~/.config/wallpaper.png \
    -k \
    --insidevercolor=00000000 --insidewrongcolor=00000000 --insidecolor=00000000 \
    --ringvercolor=98c040 --ringwrongcolor=d02828 --ringcolor=00000000 \
    --linecolor=00000000 --keyhlcolor=2060a0 --bshlcolor=d06020 \
    --verifcolor=b8f080 --wrongcolor=ff8080 --separatorcolor=00000000 \
    --indpos=x+w/7:y+h-w/8 \
    --{time,date}-font=monospace --{layout,verif,wrong,greeter}size=28 \
    --timecolor=60b8ff --timesize=36 \
    --datepos=ix:iy+36 --datecolor=e0a878 --datestr=%F --datesize=28 \
    --veriftext=Verifying... --wrongtext="Try again!" --noinputtext="No input" \
    --locktext=Locking... --lockfailedtext="Lock failed!" \
    --radius 108 --ring-width 8 &
exec awesome
