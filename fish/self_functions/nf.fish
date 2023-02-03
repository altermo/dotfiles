function nf #TODO
    set -l savefile /tmp/nf-date.lock
    type fd -q||return 1
    touch $savefile
    set d (cat $savefile)
    if test -z "$d"
        set d "2000-01-01 00:00:00"
    end
    cd ~/.config/nvim
    if fd  -H -t f --changed-after $d -1 -q; or not test -e /tmp/nf-nvim.sock
        echo 1
        nvim-qt $argv
    else
        echo 2
        nvim-qt --server /tmp/nf-nvim.sock $argv
    end
    cd -
    bash -c "setsid nvim --headless --listen /tmp/nf-nvim.sock"
    date +"%Y-%m-%d %H:%M:%S">$savefile
end
