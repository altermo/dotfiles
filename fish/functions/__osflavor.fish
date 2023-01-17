# author: T.Imanishi
function __osflavor --description 'Write out OS-flavored symbols'
    # last command exit status
    set -q __osflavor_last_status; or set -l __osflavor_last_status 0

    set -l status_style (set_color normal)
    if test $__osflavor_last_status -ne 0
        set status_style (set_color -d -u)
    end

    # pre-defined color
    set -l black (set_color black)
    set -l red (set_color red)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l blue (set_color blue)
    set -l magenta (set_color magenta)
    set -l cyan (set_color cyan)
    set -l white (set_color white)
    set -l normal (set_color normal)

    # Load Nerd Font single icons
    if test $__osflavor_use_nerd_font_icon -ne 0
        __osflavor_load_nerd_icons
    end

    # default prompt
    set -l arrow $__osflavor_dist_OTHERS

    # OS-flavored prompt
    # search defined $__osflavor_dist_{distname} within uname description
    if not set -q __osflavor_uname
        set __osflavor_uname (uname -a|string lower)
    end
    for x in (set -n | grep '__osflavor_dist_')
        set -l distname (string sub -s 17 $x)
        if string match -q "*$distname*" $__osflavor_uname
            set arrow (eval echo '$__osflavor_dist_'$distname)
            break
        end
    end

    if test "$USER" = 'root'
        set arrow "$red#"
    end

    echo -n -s $status_style $arrow $normal
end
