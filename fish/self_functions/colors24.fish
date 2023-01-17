function rgbcolor
    printf "\e[48;2;%s;%s;%sm " $argv
end
function calcolor
    set h (math -s0 $argv/43)
    set f (math -s0 $argv-43\*$h)
    set t (math -s0 $f\*255/43)
    set q (math -s0 255-$t)
    if [ $h -eq 0 ]
        printf 255\n$t\n0
    else if [ $h -eq 1 ]
        printf $q\n255\n0
    else if [ $h -eq 2 ]
        printf 0\n255\n$t
    else if [ $h -eq 3 ]
        printf 0\n$q\n255
    else if [ $h -eq 4 ]
        printf $t\n0\n255
    else if [ $h -eq 5 ]
        printf 255\n0\n$q
    end
end
function reset
    printf "\e[0m\n"
end
function colors24
    for i in (seq 0 127)
        rgbcolor $i 0 0
    end
    reset
    for i in (seq 255 -1 128)
        rgbcolor $i 0 0
    end
    reset
    for i in (seq 0 127)
        rgbcolor 0 $i 0
    end
    reset
    for i in (seq 255 -1 128)
        rgbcolor 0 $i 0
    end
    reset
    for i in (seq 0 127)
        rgbcolor 0 0 $i
    end
    reset
    for i in (seq 255 -1 128)
        rgbcolor 0 0 $i
    end
    reset
    for i in (seq 0 127)
        rgbcolor (calcolor $i)
    end
    reset
    for i in (seq 255 -1 128)
        rgbcolor (calcolor $i)
    end
    reset
end
