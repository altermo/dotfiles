function devour
    set wid (xdotool getactivewindow)
    xdotool windowunmap $wid
    fish -i -c "$argv"
    xdotool windowmap $wid
end
