function cosy
    set winlist (wmctrl -l|cut -d\  -f1|sort|string split0)
    setsid alacritty -o window.opacity=0 -e fish -ic '_cosy_rep'
    sleep 0.5
    set winlist2 (wmctrl -l|cut -d\  -f1|sort|string split0)
    set win (diff (echo $winlist|psub) (echo $winlist2|psub)|grep ">"|cut -d\  -f2)
    if not test "$win";return 2;end
    qtile cmd-obj -o window (math "$win") -f enable_fullscreen
    qtile cmd-obj -o window (math "$win") -f static
    qtile cmd-obj -o cmd -f reload_config
    for i in (wmctrl -l)
        echo $i|cut -d\  -f1|math|xargs xdotool windowstate --toggle FULLSCREEN
        echo $i|cut -d\  -f1|math|xargs xdotool windowstate --toggle FULLSCREEN
    end
end
