function cosy
    set winlist (wmctrl -l|string split0)
    setsid alacritty -o window.opacity=0 -e fish -C 'alias exit stop'
    sleep 0.5
    set win (diff (echo $winlist|sort|psub) (wmctrl -l|sort|psub)|grep ">"|cut -d\  -f2)
    if not test "$win";return 2;end
    qtile cmd-obj -o window (math "$win") -f enable_fullscreen
    qtile cmd-obj -o window (math "$win") -f static
    qtile cmd-obj -o cmd -f reload_config
    for i in (wmctrl -l)
        echo $i|cut -d\  -f1|math|xargs xdotool windowstate --toggle FULLSCREEN
        echo $i|cut -d\  -f1|math|xargs xdotool windowstate --toggle FULLSCREEN
    end
end
