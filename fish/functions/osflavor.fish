# author: T.Imanishi
function osflavor -a cmd --description 'Write out OS-flavored symbols'
    switch "$cmd"
        case '' -h --help
            echo "usage: osflavor list        list defined symbols"
            echo "       osflavor set  <name> set prompt as the other distribution"
            echo "       osflavor set         clear prompt setting"
        case list
            for x in (set -n | grep '__osflavor_dist_')
                printf "%-35s%s" $x $$x
                printf (set_color normal)"\n"
            end
        case set
            if test -n "$argv[2]"
                set -g __osflavor_uname $argv[2]
            else
                set -q __osflavor_uname; and set -e __osflavor_uname; and printf '$__osflavor_uname is cleared'
            end
        case '*'
            echo "osflaver: unknown flag or command (see `osflavor -h`)" && return 1
    end
end
