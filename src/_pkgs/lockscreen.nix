{ pkgs, root }:

let
  inherit (pkgs) i3lock-color writers;
  inherit (root.colors) blue green lightred orange;
in

writers.writeBashBin "lockscreen" ''
  ${i3lock-color}/bin/i3lock-color \
    -i ~/.config/wallpaper.png -k \
    --{inside{ver,wrong,},ring,line,separator}-color=00000000 \
    --ringver-color=${green} --ringwrong-color=${lightred} \
    --keyhl-color=${blue} --bshl-color=${orange} \
    --verif-color=${green} --wrong-color=${lightred} \
    --ind-pos=x+w/7:y+h-w/8 \
    --{time,date}-font=monospace \
    --{layout,verif,wrong,greeter}-size=14 \
    --time-color=${blue} --time-size=16 \
    --date-pos=ix:iy+16 --date-color=${green} --date-str=%F --date-size=12 \
    --verif-text=Verifying... \
    --wrong-text="Try again!" \
    --noinput-text="No input" \
    --lock-text=Locking... --lockfailed-text="Lock failed!" \
    --radius 48 --ring-width 4
''
