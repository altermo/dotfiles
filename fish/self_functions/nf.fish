function nf #TODO
    set -l savefile /tmp/nf-date.lock
    type fd -q||return 1
    touch $savefile
    set s (cat $savefile)
    set d $s[1]
    set id $s[2]
    if test -z "$d"
        set d "2000-01-01 00:00:00"
    end
    cd ~/.config/nvim
    if fd  -H -t f --changed-after $d -1 -q;or test -z "$id"
        echo 1
        nvim-qt $argv &
    else
        echo 2
        nvim-qt --server $id $argv &
    end
    cd -
    set newd (date +"%Y-%m-%d %H:%M:%S")
    set id (mktemp -u -t "nf-sock-XXXX")
    bash -c "setsid nvim --headless --listen $id"  #TODO: use neovims own $NVIM
    echo $newd>$savefile
    echo $id>>$savefile
end
