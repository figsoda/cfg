CM_MAX_CLIPS=20 CM_SELECTIONS=clipboard clipmenud &
mpd &
nm-applet &
thunar --daemon &
udiskie -s &
unclutter --timeout 3 &
volctl &
xss-lock -l -- \
    i3lock-color -i ~/.config/wallpaper.png -k \
    --{inside{ver,wrong,},ring,line,separator}color=00000000 \
    --ringvercolor=98c040 --ringwrongcolor=d02828 \
    --keyhlcolor=2060a0 --bshlcolor=d06020 \
    --verifcolor=b8f080 --wrongcolor=ff8080 \
    --indpos=x+w/7:y+h-w/8 \
    --{time,date}-font=monospace --{layout,verif,wrong,greeter}size=32 \
    --timecolor=60b8ff --timesize=36 \
    --datepos=ix:iy+36 --datecolor=e0a878 --datestr=%F --datesize=28 \
    --veriftext=Verifying... --wrongtext="Try again!" --noinputtext="No input" \
    --locktext=Locking... --lockfailedtext="Lock failed!" \
    --radius 108 --ring-width 8 &
exec awesome
