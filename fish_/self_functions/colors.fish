function _colors24
    function rgbcolor;printf "\e[48;2;%s;%s;%sm " $argv;end
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
    function reset;printf "\e[0m\n";end
    for i in (seq 0 127);rgbcolor $i 0 0;end
    reset
    for i in (seq 255 -1 128);rgbcolor $i 0 0;end
    reset
    for i in (seq 0 127);rgbcolor 0 $i 0;end
    reset
    for i in (seq 255 -1 128);rgbcolor 0 $i 0;end
    reset
    for i in (seq 0 127);rgbcolor 0 0 $i;end
    reset
    for i in (seq 255 -1 128);rgbcolor 0 0 $i;end
    reset
    for i in (seq 0 127);rgbcolor (calcolor $i);end
    reset
    for i in (seq 255 -1 128);rgbcolor (calcolor $i);end
    reset
end
function _colorsname
    printf "\e[40;37m Black "
    printf "\e[41;37m Red "
    printf "\e[42;37m Green "
    printf "\e[43;30m Yellow "
    printf "\e[44;37m Blue "
    printf "\e[45;37m Magenta "
    printf "\e[46;30m Cyan "
    printf "\e[47;30m White "
    printf "\n"
    printf "\e[100;37m LightBlack "
    printf "\e[101;30m LightRed "
    printf "\e[102;30m LightGreen "
    printf "\e[103;30m LightYellow "
    printf "\e[104;30m LightBlue "
    printf "\e[105;30m LightMagenta "
    printf "\e[106;30m LightCyan "
    printf "\e[107;30m LightWhite "
    printf "\n"
end
function _colors
    function prcolor
        printf "\e[48:5:$argv[1]""m$argv[2]"
    end
    alias res 'printf "\e[0m\n"'
    for i in (seq 0 15);prcolor $i " ";end
    res
    for i in (seq 16 231);prcolor $i " ";[ (math $i%36) = 15 ]&&res;end
    for i in (seq 232 255);prcolor $i " ";end
    res
end
function _styles;for i in (seq 110);printf "\e[$i""m$i\t\e[m";[ (math $i%10) = 0 ]&&echo;end;end
function colors
    if test "$argv" = 24
        _colors24
    else if test "$argv" = name
        _colorsname
    else if test "$argv" = style
        _styles
    else
        _colors
    end
end
